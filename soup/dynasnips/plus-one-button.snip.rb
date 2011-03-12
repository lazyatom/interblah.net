class PlusOneButton < Dynasnip
  def handle(text='+1')
    messages = [
      "ARE YOU KIDDING?!",
      "ARE YOU FUCKING TESTING ME?!",
      "ARE YOU SERIOUS?!",
      "I mean... come on.",
      "Well done, wiseass.",
      "Bravo sir. BRA-FUCKING-VO.",
      "I suppose you want a medal now, right?"
    ]
    message = messages[rand(messages.length)]
    %{<button onclick="alert('#{message}')">#{text}</button>}
  end
  self
end