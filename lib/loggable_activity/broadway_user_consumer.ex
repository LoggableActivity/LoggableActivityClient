defmodule LoggableActivity.BroadwayUserConsumer do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayRabbitMQ.Producer,
           queue: "users_queue",
           connection: [
             host: "localhost",
             username: "guest",
             password: "guest"
           ]},
        concurrency: 10
      ],
      processors: [
        default: [concurrency: 10]
      ]
    )
  end

  @impl true
  def handle_message(_processor_name, %Message{data: data} = message, _context) do
    IO.inspect(data, label: "Consumed message")

    # Here you can process the message
    # For example, you could save it to the database

    message
  end
end
