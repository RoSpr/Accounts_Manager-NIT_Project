# Accounts_Manager-NIT_Project
## Менеджер учёта финансов

#### Возможности приложения
В приложении реализованы такие возможности, как:
- добавление и удаление категорий учёта расходов/доходов;
- добавление и удаление расходов/доходов за выбранную дату;
- подсчёт расходов и доходов в каждой категории за всё время использования;
- получение актуальных курсов к рублю наиболее популярных валют с сайта https://www.cbr-xml-daily.ru.

#### Экраны
Всего в приложении 3 экрана. **Первый**, на который попадает пользователь при запуске, отображает добавленные категории и суммарные расходы и доходы в каждой из них. По нажатию на копку "Обновить данные" категории обновляются - это необходимо в случае добавления или удаления категорий или изменения расходов/доходов. Над списком категорий находится выпадающее окно с конвертером валют, раскрывающийся по нажатию на текст "Конвертер валют". В нем пользователю предлагается выбрать валюту из выпадающего списка и ввести её количества для подсчета суммы в рублях.
**Второй экран** также содержит список добавленных категорий, каждая из которых содержит кнопку "Удалить". Над списком категорий находится выпадающее окно с добавлением категорий. При нажатии на категорию открывается **третий экран** с названием выбранной категории, где пользователь может выбрать дату (при первом открытии их выбор ограничивается последними 31 днями, включающими текущий) и добавить расходы с доходами. Сразу после выбора даты на экране отображаются уже введённые доходы и расходы.


На каждом из экранов добавлена обработка некорретконого ввода со стороны пользователя - например, в случае ввода букв в поле для количества валюты будет показано сообщение с просьбой ввести количество валюты цифрами.

***

##### Создано в рамках курса iOS App Dev Online от Napoleon IT.