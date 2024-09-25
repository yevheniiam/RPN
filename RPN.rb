# Функція, яка визначає пріоритет операторів
def operator_precedence(op)
  case op
  when '+', '-'
    return 1  # Складення та віднімання мають пріоритет 1
  when '*', '/'
    return 2  # Множення та ділення мають пріоритет 2
  else
    return 0  # Невідомі оператори мають пріоритет 0
  end
end

# Перевіряє, чи є рядок числом
def is_number(str)
  return str.match?(/\A-?\d+(\.\d+)?\z/)  # Перевірка на ціле або дробове число
end

# Додає елемент в масив
def add_output(output, el)
  output << el  # Додає елемент до виходу
end

# Обробляє закриту дужку
def handle_closing_bracket(output, operators_stack)
  # Витягуємо оператори з стеку до відкритої дужки
  while !operators_stack.empty? && operators_stack.last != '('
    add_output(output, operators_stack.pop)  # Додаємо оператор до виходу
  end
  operators_stack.pop  # Видаляємо '(' зі стеку
end

# Обробляє оператор
def handle_operator(output, operators_stack, operator)
  # Порівнюємо пріоритети операторів
  while !operators_stack.empty? && operator_precedence(operators_stack.last) >= operator_precedence(operator)
    add_output(output, operators_stack.pop)  # Додаємо оператор до виходу
  end
  operators_stack.push(operator)  # Додаємо новий оператор у стек
end

# Розбиває рядок на токени
def split_expression_to_tokens(expression)
  tokens = []  # Масив для зберігання токенів
  temp_token = ''  # Тимчасовий токен для чисел

  # Проходимо по кожному символу рядка
  expression.each_char.with_index do |char, i|
    # Перевіряємо, чи символ є цифрою
    is_digit = char =~ /\d/
    # Перевіряємо, чи символ є крапкою
    is_dot = char == '.'
    # Перевіряємо, чи символ є '-' і на правильній позиції
    is_minus = char == '-' && (i == 0 || expression[i - 1] == '(')

    # Якщо символ - цифра, крапка або знак '-'
    if is_digit || is_dot || is_minus
      temp_token += char  # Додаємо символ до тимчасового токена
    else
      unless temp_token.empty?
        tokens << temp_token  # Додаємо тимчасовий токен до масиву
        temp_token = ''  # Очищаємо тимчасовий токен
      end
      tokens << char unless char == ' '  # Додаємо оператор, якщо не пробіл
    end
  end

  tokens << temp_token unless temp_token.empty?  # Додаємо останній токен, якщо він не порожній
  return tokens  # Повертаємо масив токенів
end

# Основна функція для конвертації виразу в RPN (обернена польська нотація)
def convert_infix_to_rpn(expression)
  output = []  # Тут буде результат
  operators_stack = []  # Стек для операторів

  tokens = split_expression_to_tokens(expression)  # Розбиваємо на токени

  # Проходимо по кожному токену
  tokens.each do |token|
    if is_number(token)
      add_output(output, token)  # Якщо токен - число, додаємо до виходу
    elsif token == '('
      operators_stack.push(token)  # Додаємо відкриту дужку до стеку
    elsif token == ')'
      handle_closing_bracket(output, operators_stack)  # Обробляємо закриту дужку
    else
      handle_operator(output, operators_stack, token)  # Обробляємо оператор
    end
  end

  # Переміщаємо залишені оператори в вихідний масив
  while !operators_stack.empty?
    add_output(output, operators_stack.pop)  # Додаємо оператори до виходу
  end

  return output.join(' ')  # Повертаємо результат у вигляді рядка
end

# Запитуємо у користувача вираз
puts "Enter a mathematical expression:"
input_expr = gets.chomp

# Перетворюємо вираз у постфіксну нотацію
rpn_result = convert_infix_to_rpn(input_expr)
puts "Reverse Polish Notation: #{rpn_result}"
