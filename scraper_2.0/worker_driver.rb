# frozen_string_literal: true

class WorkerDriver
  def initialize(queue:, worker_class:, threads_count: 1, **worker_opts)
    @queue = queue
    @worker_class = worker_class
    @threads_count = threads_count
    @worker_opts = worker_opts
    @threads = []
    @mutex = Mutex.new
    @running = false
  end

  def start
    @running = true
    @threads = @threads_count.times.map { Thread.new { run_loop } }
  end

  def stop
    @running = false
    @threads.each(&:join)
  end

  private

  def run_loop
    worker = @worker_class.new(**@worker_opts)

    while @running
      task = Manager.next_task(@queue)

      if task.nil?
        sleep 0.05
        next
      end

      safe_process(worker, task)
    end
  end

  def safe_process(worker, task)
    worker.call(task: task)
  rescue StandardError => e
    handle_crash(task, e)
  end

  def handle_crash(task, err)
    @mutex.synchronize { warn "[#{@queue}] Task #{task.id} crashed: #{err.message}" }
    task.fail!(err)
  end
end
