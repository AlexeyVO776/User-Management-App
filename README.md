# User Management App

## Описание

User Management App — это простое приложение для управления пользователями, их интересами и навыками. Приложение предоставляет API для создания пользователей, добавления интересов и навыков, а также выполнения различных проверок, включая валидацию полей и проверку на уникальность email.

## Требования

Для запуска проекта вам понадобятся:

- Ruby 3.x
- Rails 7.x
- PostgreSQL (или любая другая поддерживаемая база данных)
- Bundler

## Установка

1. Клонируйте репозиторий на локальную машину:

2. Установите зависимости:

    ```bash
    bundle install
    ```

3. Запустите создание и миграции базы данных:

    ```bash
    rails db:create
    rails db:migrate
    ```

4. Заполните базу данных начальными данными (интересами и навыками):

    ```bash
    rails db:seed
    ```

5. Запустите сервер:

    ```bash
    rails s
    ```

Теперь приложение доступно по адресу [http://localhost:3000](http://localhost:3000).

## Использование Postman для работы с API

### Создание пользователя

Для создания пользователя используйте следующий запрос в Postman:

1. Установите метод запроса на `POST`.
2. Укажите URL: `http://localhost:3000/users`.
3. В разделе "Body" выберите `raw` и `JSON`, затем добавьте тело запроса с примером данных:

    ```json
    {
      "user": {
        "name": "John",
        "surname": "Doe",
        "patronymic": "Paul",
        "email": "john.doe@example.com",
        "age": 30,
        "nationality": "American",
        "country": "USA",
        "gender": "male",
        "interests": ["Reading", "Music"],
        "skills": "Ruby,JavaScript"
      }
    }
    ```

4. Нажмите "Send", и если все параметры валидны, вы получите ответ с созданным пользователем:

    ```json
    {
      "id": 1,
      "name": "John",
      "surname": "Doe",
      "patronymic": "Paul",
      "email": "john.doe@example.com",
      "age": 30,
      "nationality": "American",
      "country": "USA",
      "gender": "male",
      "full_name": "Doe John Paul",
      "created_at": "2024-10-01T12:00:00Z",
      "updated_at": "2024-10-01T12:00:00Z"
    }
    ```

### Примеры ошибок

Если какой-либо параметр будет некорректным, вы получите ошибку. Пример:

#### Ошибка при дублировании email:

Запрос:

```json
{
  "user": {
    "name": "Jane",
    "surname": "Smith",
    "patronymic": "Ann",
    "email": "john.doe@example.com",
    "age": 25,
    "nationality": "American",
    "country": "USA",
    "gender": "female",
    "interests": ["Music"],
    "skills": "JavaScript"
  }
}
```

Ответ:

```json
{
  "errors": [
    "Email has already been taken"
  ]
}
```

##  Тестирование

Вы можете запустить тесты для проверки работоспособности приложения с помощью:

```bash
    rspec
```
