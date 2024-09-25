# Функція визначає пріоритет операторів
def precedence(operator)
  case operator
  when '+', '-'
    1
  when '*', '/'
    2
  else
    0
  end
end

# Перевіряє, чи є рядок числом (підтримка цілих та дробових чисел)
def is_number?(str)
  str.match?(/\A-?\d+(\.\d+)?\z/)
end

# Додає число у вихідний масив
def add_to_output(output, element)
  output << element
end

# Обробляє закриту дужку - витягує оператори до відкритої дужки
def process_closing_parenthesis(output, stack_operators)
  while stack_operators.any? && stack_operators.last != '('
    add_to_output(output, stack_operators.pop)
  end
  stack_operators.pop  # Видаляємо відкриту дужку зі стеку
end

# Обробляє оператор: порівнює пріоритети і додає в стек або вихід
def process_operator(output, stack_operators, operator)
  while stack_operators.any? && precedence(stack_operators.last) >= precedence(operator)
    add_to_output(output, stack_operators.pop)
  end
  stack_operators.push(operator)
end

# Розбиває вираз на числа та оператори (працює з виразами без пробілів)
def tokenize(expression)
  tokens = []
  current_token = ''

  expression.chars.each_with_index do |char, index|
    if char =~ /\d/ || char == '.' || (char == '-' && (index == 0 || expression[index - 1] == '('))
      current_token += char
    else
      tokens << current_token unless current_token.empty?
      current_token = ''
      tokens << char unless char.strip.empty?
    end
  end
  tokens << current_token unless current_token.empty?

  tokens
end

# Функція перетворення інфіксної нотації у постфіксну (RPN)
def infix_to_rpn(expression)
  output = []         # Вихідний масив для результату
  stack_operators = [] # Стек для збереження операторів

  elements = tokenize(expression) # Отримуємо токени (елементи) виразу

  elements.each do |element|
    if is_number?(element)
      add_to_output(output, element)  # Додаємо числа до вихідного масиву
    else
      case element
      when '('
        stack_operators.push(element)
      when ')'
        process_closing_parenthesis(output, stack_operators)
      else
        process_operator(output, stack_operators, element)
      end
    end
  end

  # Переносимо всі оператори зі стеку у вихідний масив
  while stack_operators.any?
    add_to_output(output, stack_operators.pop)
  end

  output.join(' ')  # Повертаємо результат у вигляді рядка
end

# Основний код для отримання виразу від користувача
puts "Enter a mathematical expression:"
input_expression = gets.chomp

# Перетворення виразу у постфіксну нотацію та виведення результату
rpn_output = infix_to_rpn(input_expression)
puts "Reverse Polish Notation: #{rpn_output}"
