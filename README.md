# Accounts_Manager-NIT_Project
## Financial Accounting Manager

#### App Capabilities
The app is capable of:
- adding and deleting categories of income and expenses;
- adding and deleting income and expenses for the selected date;
- summing up income and expenses in each category for the entire usage period;
- retrieving the current ruble exchange rate for the most commonly used currencies from the https://www.cbr-xml-daily.ru website.

#### App screens
The app has 3 screens. **The first one**, shown right after the user starts 

The application has a total of three screens. **The first screen**, which the user sees upon launch, displays the added categories and the total expenses and income for each. By pressing the "Update Data" button, the categories are refreshed—this is necessary in case of adding or deleting categories or modifying expenses/income. Above the category list is a dropdown window with a currency converter, which expands when the "Currency Converter" text is clicked. In it, the user can select a currency from the dropdown list and enter the amount for converting it to rubles.

**The second screen** also contains a list of added categories, each of which includes a "Delete" button. Above the list of categories is a dropdown window for adding categories.

When a category is clicked, **the third screen** opens, showing the name of the selected category, where the user can choose a date and add expenses and income. Right after selecting a date, the screen displays already entered income and expenses.

#### Additional Features
Each screen includes error handling for incorrect input — for example, if letters are entered in the currency amount field, a message will appear asking the user to input the amount in numbers.

#### Frameworks Used

The entered categories, selected dates, expenses, and income are saved on the device using the RealmSwift framework.
Dropdown lists are implemented using the DropDown framework.
The calendar for date selection is created using the FSCalendar framework.

***

##### Created as a final project of the iOS App Dev Online course by Napoleon IT.
