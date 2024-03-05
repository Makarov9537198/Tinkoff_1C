﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	НаборЯзыков = Новый ТаблицаЗначений;
	НаборЯзыков.Колонки.Добавить("КодЯзыка", ОбщегоНазначения.ОписаниеТипаСтрока(10));
	НаборЯзыков.Колонки.Добавить("Представление", ОбщегоНазначения.ОписаниеТипаСтрока(150));

	ДоступныеЯзыки = Новый Массив;
	Для Каждого Язык Из Метаданные.Языки Цикл
		ДоступныеЯзыки.Добавить(Язык.КодЯзыка);
	КонецЦикла;

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Мультиязычность.Печать") Тогда
		МодульУправлениеПечатьюМультиязычность = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатьюМультиязычность");
		ДоступныеЯзыки = МодульУправлениеПечатьюМультиязычность.ДоступныеЯзыки();
	КонецЕсли;

	Для Каждого КодЯзыка Из ДоступныеЯзыки Цикл
		НовыйЯзык = НаборЯзыков.Добавить();
		НовыйЯзык.КодЯзыка = КодЯзыка;
		НовыйЯзык.Представление = РаботаСКурсамиВалютСлужебный.ПредставлениеЯзыка(КодЯзыка);
	КонецЦикла;

	ИмеющиесяЯзыкиВводаПрописей = ИмеющиесяЯзыкиВводаПрописей();

	Для Каждого ЯзыкКонфигурации Из НаборЯзыков Цикл
		Если ИмеющиесяЯзыкиВводаПрописей.Найти(ЯзыкКонфигурации.КодЯзыка) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = Языки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЯзыкКонфигурации);
		НоваяСтрока.Имя = "_" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	КонецЦикла;

	СформироватьПоляВводаНаРазныхЯзыках(Ложь, Параметры.ТолькоПросмотр);

	ОписаниеЯзыка = ОписаниеЯзыка(ТекущийЯзык().КодЯзыка);
	Если ОписаниеЯзыка <> Неопределено Тогда
		ЭтотОбъект[ОписаниеЯзыка.Имя] = Параметры.ТекущееЗначение;
	КонецЕсли;

	ОсновнойЯзык = ОбщегоНазначения.КодОсновногоЯзыка();

	Для Каждого Представление Из Параметры.Представления Цикл

		ОписаниеЯзыка = ОписаниеЯзыка(Представление.КодЯзыка);
		Если ОписаниеЯзыка <> Неопределено Тогда
			Если СтрСравнить(ОписаниеЯзыка.КодЯзыка, ТекущийЯзык().КодЯзыка) = 0 Тогда
				ЭтотОбъект[ОписаниеЯзыка.Имя] = ?(ЗначениеЗаполнено(Параметры.ТекущееЗначение),
					Параметры.ТекущееЗначение, Представление[Параметры.ИмяРеквизита]);
			Иначе
				ЭтотОбъект[ОписаниеЯзыка.Имя] = Представление[Параметры.ИмяРеквизита];
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	СуммаЧисло = 123.45;
	УстановитьСуммуПрописью();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)

	УстановитьСуммуПрописью();

КонецПроцедуры

&НаКлиенте
Процедура СуммаЧислоПриИзменении(Элемент)

	УстановитьСуммуПрописью();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеВводаПриИзменении(Элемент)

	Модифицированность = Истина;
	УстановитьСуммуПрописью();
	ОповеститьВладельца();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеВводаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)

	Модифицированность = Истина;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)

	ОповеститьВладельца(Истина, Истина);

КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)

	ОповеститьВладельца(Истина);
	Модифицированность = ВладелецФормы.Модифицированность;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьПоляВводаНаРазныхЯзыках(МногострочныйРежим, ТолькоПросмотр)

	Добавлять = Новый Массив;
	ТипСтрока = Новый ОписаниеТипов("Строка");
	Для Каждого ЯзыкКонфигурации Из Языки Цикл
		Добавлять.Добавить(Новый РеквизитФормы(ЯзыкКонфигурации.Имя, ТипСтрока, , ЯзыкКонфигурации.Представление));
		Добавлять.Добавить(Новый РеквизитФормы("ПодсказкаВвода" + ЯзыкКонфигурации.Имя, ТипСтрока, ,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Подсказка ввода для языка %1'"),
			ЯзыкКонфигурации.Представление)));
	КонецЦикла;

	ИзменитьРеквизиты(Добавлять);
	РодительЭлементов = Элементы.Страницы;

	Для Каждого ЯзыкКонфигурации Из Языки Цикл

		Если СтрСравнить(ЯзыкКонфигурации.КодЯзыка, ТекущийЯзык().КодЯзыка) = 0
			И РодительЭлементов.ПодчиненныеЭлементы.Количество() > 0 Тогда
			Страница = Элементы.Вставить("Страница" + ЯзыкКонфигурации.Имя, Тип("ГруппаФормы"), РодительЭлементов,
				РодительЭлементов.ПодчиненныеЭлементы.Получить(0));
		Иначе
			Страница = Элементы.Добавить("Страница" + ЯзыкКонфигурации.Имя, Тип("ГруппаФормы"), РодительЭлементов);
		КонецЕсли;

		ЯзыкКонфигурации.Страница = Страница.Имя;

		Страница.Вид = ВидГруппыФормы.Страница;
		Страница.Заголовок = ЯзыкКонфигурации.Представление;

		ПолеВвода = Элементы.Добавить(ЯзыкКонфигурации.Имя, Тип("ПолеФормы"), Страница);
		ПолеВвода.ПутьКДанным = ЯзыкКонфигурации.Имя;

		Если ЗначениеЗаполнено(ЯзыкКонфигурации.ФормаРедактирования) Тогда
			ПолеВвода.Вид = ВидПоляФормы.ПолеНадписи;
			ПолеВвода.Гиперссылка = Истина;
			ПолеВвода.УстановитьДействие("Нажатие", "Подключаемый_Нажатие");
		Иначе
			ПолеВвода.Вид                = ВидПоляФормы.ПолеВвода;
			ПолеВвода.Ширина             = 40;
			ПолеВвода.МногострочныйРежим = МногострочныйРежим;
			ПолеВвода.ТолькоПросмотр     = ТолькоПросмотр;
			ПолеВвода.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			ПолеВвода.УстановитьДействие("ПриИзменении", "Подключаемый_ПолеВводаПриИзменении");
			ПолеВвода.УстановитьДействие("ИзменениеТекстаРедактирования",
				"Подключаемый_ПолеВводаИзменениеТекстаРедактирования");

			Подсказка = ПодсказкаЗаполненияПараметровПрописей(ЯзыкКонфигурации.КодЯзыка);
			ПолеВвода.ПодсказкаВвода = Подсказка.ПодсказкаВвода;

			ПодсказкаВвода = Элементы.Добавить("ПодсказкаВвода" + ЯзыкКонфигурации.Имя, Тип("ПолеФормы"), Страница);
			ПодсказкаВвода.ПутьКДанным = "ПодсказкаВвода" + ЯзыкКонфигурации.Имя;
			ПодсказкаВвода.Вид = ВидПоляФормы.ПолеВвода;
			ПодсказкаВвода.ТолькоПросмотр = Истина;
			ПодсказкаВвода.ЦветТекста = ЦветаСтиля.ПоясняющийТекст;
			ПодсказкаВвода.РастягиватьПоВертикали = Истина;
			ПодсказкаВвода.АвтоМаксимальнаяВысота = Ложь;
			ПодсказкаВвода.МногострочныйРежим = Истина;
			ПодсказкаВвода.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			ПодсказкаВвода.ЦветРамки = ЦветаСтиля.ЦветФонаФормы;

			Если Не ЗначениеЗаполнено(Подсказка.Инструкция) Тогда
				Подсказка.Инструкция = НСтр("ru = 'Для данного языка настройка прописи не предусмотрена.'");
			КонецЕсли;
			
			ЭтотОбъект["ПодсказкаВвода" + ЯзыкКонфигурации.Имя] = Подсказка.Инструкция;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ОписаниеЯзыка(КодЯзыка)

	Отбор = Новый Структура("КодЯзыка", КодЯзыка);
	НайденныеЭлементы = Языки.НайтиСтроки(Отбор);
	Если НайденныеЭлементы.Количество() > 0 Тогда
		Возврат НайденныеЭлементы[0];
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

&НаКлиенте
Процедура УстановитьСуммуПрописью()

	ТекущийЯзык = ОписаниеТекущегоЯзыка();
	Если ТекущийЯзык = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПрописи = ЭтотОбъект[ТекущийЯзык.Имя];
	СуммаПрописью = ЧислоПрописью(СуммаЧисло, "L=" + ТекущийЯзык.КодЯзыка + ";ДП=Ложь", ПараметрыПрописи); // АПК:1357

КонецПроцедуры

&НаКлиенте
Функция ОписаниеТекущегоЯзыка()

	ТекущаяСтраница = Элементы.Страницы.ТекущаяСтраница;
	Если ТекущаяСтраница = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат Языки.НайтиСтроки(Новый Структура("Страница", ТекущаяСтраница.Имя))[0];

КонецФункции

&НаКлиенте
Процедура ОповеститьВладельца(Записать = Ложь, Закрыть = Ложь)

	ТекущийЯзык = ОписаниеТекущегоЯзыка();

	ПараметрыПрописи = Новый Структура;
	ПараметрыПрописи.Вставить("КодЯзыка", ТекущийЯзык.КодЯзыка);
	ПараметрыПрописи.Вставить("ПараметрыПрописи", ЭтотОбъект[ТекущийЯзык.Имя]);
	ПараметрыПрописи.Вставить("Записать", Записать);
	ПараметрыПрописи.Вставить("Закрыть", Закрыть);

	Оповестить("ПараметрыПрописиВалюты", ПараметрыПрописи, ВладелецФормы);

КонецПроцедуры

&НаСервере
Функция ИмеющиесяЯзыкиВводаПрописей()

	Возврат РаботаСКурсамиВалютСлужебный.ФормыВводаПрописей().ВыгрузитьЗначения();

КонецФункции

&НаСервере
Функция ПодсказкаЗаполненияПараметровПрописей(Знач КодЯзыка)

	Результат = Новый Структура;
	Результат.Вставить("Инструкция", "");
	Результат.Вставить("ПодсказкаВвода", "");

	Если Не ЗначениеЗаполнено(КодЯзыка) Тогда
		Возврат Результат;
	КонецЕсли;

	КодЯзыка = СтрРазделить(КодЯзыка, "_", Истина)[0];

	Если КодЯзыка = "ru" Или КодЯзыка = "be" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для русского и белорусского языков (ru_RU, be_BY):
		|
		|рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2
		|
		|""рубль, рубля, рублей, м"" – предмет исчисления:
		|рубль – единственное число именительный падеж;
		|рубля – единственное число родительный падеж;
		|рублей – множественное число родительный падеж;
		|м – мужской род (ж – женский род, с - средний род);
		|""копейка, копейки, копеек, ж"" – дробная часть, аналогично предмету исчисления (может отсутствовать);
		|""2"" – количество разрядов дробной части (может отсутствовать, по умолчанию равно 2).'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2'");

	ИначеЕсли КодЯзыка = "uk" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для украинского языка (uk_UA):
		|
		|гривна, гривны, гривен, м, копейка, копейки, копеек, ж, 2
		|
		|""гривна, гривны, гривен, м"" – предмет исчисления:
		|""гривна – единственное число именительный падеж;
		|гривны – единственное число родительный падеж;
		|гривен – множественное число родительный падеж;
		|м – мужской род (ж – женский род, с - средний род);
		|""копейка, копейки, копеек, ж"" – дробная часть, аналогично предмету исчисления (может отсутствовать);
		|""2"" – количество разрядов дробной части (может отсутствовать, по умолчанию равно 2).'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'гривна, гривны, гривен, м, копейка, копейки, копеек, ж, 2'");

	ИначеЕсли КодЯзыка = "pl" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для польского языка (pl_PL):
		|
		|złoty, złote, złotych, m, grosz, grosze, groszy, m, 2
		|
		|""złoty, złote, złotych, m "" - предмет исчисления (m - мужской род, ż - женский род, ń - средний род, mo – личностный мужской род).
		|złoty - единственное число именительный падеж;
		|złote - единственное число винительный падеж;
		|złotych - множественное число винительный падеж;
		|m - мужской род (ż - женский род, ń - средний род, mo – личностный мужской род);
		|""grosz, grosze, groszy, m "" - дробная часть (может отсутствовать) (аналогично целой части);
		|2 - количество разрядов дробной части (может отсутствовать, по умолчанию равно 2).'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'złoty, złote, złotych, m, grosz, grosze, groszy, m, 2'");

	ИначеЕсли КодЯзыка = "en" Или КодЯзыка = "fr" Или КодЯзыка = "fi" Или КодЯзыка = "kk" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для английского, французского, финского и казахского языков (en_US, fr_CA,fi_FI, kk_KZ):
		|
		|dollar, dollars, cent, cents, 2
		|
		|""dollar, dollars"" – предмет исчисления в единственном и множественном числе;
		|""cent, cents"" – дробная часть в единственном и множественном числе (может отсутствовать);
		|""2"" – количество разрядов дробной части (может отсутствовать, по умолчанию равно 2).'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'dollar, dollars, cent, cents, 2'");

	ИначеЕсли КодЯзыка = "de" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для немецкого языка (de_DE):
		|
		|EURO, EURO, М, Cent, Cent, M, 2
		|
		|""EURO, EURO, М"" – предмет исчисления:
		|EURO, EURO – предмет исчисления в единственном и множественном числе;
		|М – мужской род (F – женский род, N - средний род);
		|""Cent, Cent, M"" – дробная часть, аналогично предмету исчисления (может отсутствовать);
		|""2"" – количество разрядов дробной части (может отсутствовать, по умолчанию равно 2).'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'EURO, EURO, М, Cent, Cent, M, 2'");

	ИначеЕсли КодЯзыка = "lv" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для латышского языка (lv_LV):
		|
		|lats, lati, latu, V, santīms, santīmi, santīmu, V, 2, J, J
		|
		|""lats, lati, latu, v"" – предмет исчисления:
		|lats – для чисел заканчивающихся на 1, кроме 11;
		|lati – для чисел заканчивающихся на 2-9 и 11;
		|latu – множественное число (родительный падеж) используется после числительных 0, 10, 20,..., 90, 100, 200, ..., 1000, ..., 100000;
		|v – мужской род (s – женский род);
		|""santīms, santīmi, santīmu, V"" – дробная часть, аналогично предмету исчисления (может отсутствовать);
		|""2"" – количество разрядов дробной части (может отсутствовать, по умолчанию равно 2);
		|""J"" - число 100 выводится как ""Одна сотня"" для предмета исчисления (N - как ""Сто"");
		|может отсутствовать, по умолчанию равно ""J"";
		|""J"" - число 100 выводится как ""Одна сотня"" для дробной части (N - как ""Сто"");
		|может отсутствовать, по умолчанию равно ""J"".'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'lats, lati, latu, V, santīms, santīmi, santīmu, V, 2, J, J'");

	ИначеЕсли КодЯзыка = "lt" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для литовского языка (lt_LT):
		|
		|litas, litai, litų, М, centas, centai, centų, М, 2
		|
		|""litas, litai, litų, М"" – предмет исчисления:
		|litas - единственное число целой части;
		|litai - множественное число целой части от 2 до 9;
		|litų - множественное число целой части прочие;
		|m - род целой части (f - женский род),
		|""centas, centai, centų, М"" – дробная часть, аналогично предмету исчисления (может отсутствовать);
		|""2"" - количество разрядов дробной части (может отсутствовать, по умолчанию равно 2).'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'litas, litai, litų, М, centas, centai, centų, М, 2'");

	ИначеЕсли КодЯзыка = "et" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для эстонского языка (et_EE):
		|
		|kroon, krooni, sent, senti, 2
		|
		|""kroon, krooni"" – – предмет исчисления в единственном и множественном числе;
		|""sent, senti"" – дробная часть в единственном и множественном числе (может отсутствовать);
		|2 – количество разрядов дробной части (может отсутствовать, по умолчанию равно 2).'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'kroon, krooni, sent, senti, 2'");

	ИначеЕсли КодЯзыка = "bg" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для болгарского языка (bg_BG):
		|
		|лев, лева, м, стотинка, стотинки, ж, 2
		|
		|""лев, лева, м"" – предмет исчисления:
		|лев - единственное число целой части;
		|лева - множественное число целой части;
		|м - род целой части,
		|""стотинка, стотинки, ж"" - дробная часть:
		|стотинка - единственное число дробной части;
		|стотинки - множественное число дробной части;
		|ж - род дробной части,
		|""2"" - количество разрядов дробной части.'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'лев, лева, м, стотинка, стотинки, ж, 2'");

	ИначеЕсли КодЯзыка = "ro" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для румынского языка (ro_RO):
		|
		|leu, lei, M, ban, bani, W, 2
		|
		|""leu, lei, M"" – предмет исчисления:
		|leu - единственное число целой части;
		|lei - множественное число целой части;
		|M - род целой части;
		|""ban, bani, W"" - дробная часть:
		|ban - единственное число дробной части;
		|bani - множественное число дробной части;
		|W - род дробной части;
		|""2"" - количество разрядов дробной части.'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'leu, lei, M, ban, bani, W, 2'");

	ИначеЕсли КодЯзыка = "ka" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для грузинского языка (ka_GE):
		|
		|ლარი, თეთრი, 2
		|
		|ლარი - целая часть;
		|თეთრი - дробная часть;
		|""2"" - количество разрядов дробной части.'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'ლარი, თეთრი, 2'");

	ИначеЕсли КодЯзыка = "az" Или КодЯзыка = "tk" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для азербайджанского(az) и туркменского языков(tk):
		|
		|TL,Kr,2
		|
		|""TL"" - предмет исчисления;
		|""Kr"" - дробная часть (может отсутствовать);
		|2 - количество разрядов дробной части (может отсутствовать, по умолчанию - 2)'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'TL,Kr,2'");

	ИначеЕсли КодЯзыка = "vi" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для вьетнамского языка (vi_VN):
		|
		|dong, xu, 2
		|
		|dong, - целая часть;
		|xu, - дробная часть;
		|2 - количество разрядов дробной части.'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'dong, xu, 2'");

	ИначеЕсли КодЯзыка = "tr" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для турецкого языка (tr_TR):
		|
		|TL,Kr,2,Separate
		|
		|TL - целая часть;
		|Kr - дробная часть (может отсутствовать);
		|2 - количество разрядов дробной части (может отсутствовать, значение по умолчанию - 2);
		|""Separate"" - признак написания прописи раздельно, ""Solid"" - слитно (может отсутствовать, по умолчанию слитно).'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'TL,Kr,2,Separate'");

	ИначеЕсли КодЯзыка = "hu" Тогда

		Результат.Инструкция = СтроковыеФункции.ФорматированнаяСтрока(НСтр(
		"ru = 'Перечислите параметры прописи через запятую.
		|Образец заполнения для венгерского языка (hu):
		|
		|Forint, fillér, 2
		|
		|Forint - целая часть;
		|fillér - дробная часть;
		|""2"" - количество разрядов дробной части.'"));

		Результат.ПодсказкаВвода = НСтр("ru = 'Forint, fillér, 2'");

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти