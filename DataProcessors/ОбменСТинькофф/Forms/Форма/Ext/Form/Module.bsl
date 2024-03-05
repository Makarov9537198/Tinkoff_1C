﻿
&НаСервере
Процедура ПускНаСервере(Команда, Параметры)
	
	//token="t.qzIVv58CYPvPe50AB2qBf7_LzH1eVOxm7jw0fgXrJxeuooSLDyR4fdVreXPU6s_uKpXKsM1OdfMbEV1PP2dAgg";
	//ИмяСервера = "invest-public-api.tinkoff.ru/rest";	
	token = Подключение.Токен;
	ИмяСервера = Подключение.Адрес;
	СтрокаЗапросаИТело = ПолучитьСтрокуЗапросаИТело(Команда, Параметры);
	Рез = Обмен(ИмяСервера, token, СтрокаЗапросаИТело.СтрокаЗапроса, СтрокаЗапросаИТело.ТелоЗапроса);
	ЗначениеВРеквизитФормы(РазвернутьВДерево( РеквизитФормыВЗначение("Дерево"), Рез ), "Дерево" );
КонецПроцедуры

&НаСервереБезКонтекста
Функция РазвернутьВДерево( Дерево, Данные, Параметр = "" )
	Для Каждого Ст ИЗ Данные Цикл 
		Если ТипЗнч(Ст) = Тип("КлючИЗначение") Тогда 
			Строка = Дерево.Строки.Добавить();
			Строка.Параметр = Ст.Ключ;
			Если ТипЗнч(Ст.Значение) = Тип("Структура") 
				ИЛИ ТипЗнч(Ст.Значение) = Тип("Массив") Тогда 
				РазвернутьВДерево( Строка, Ст.Значение, Ст.Ключ );
			Иначе
				Строка.Значение =  Ст.Значение
			КонецЕсли;
		Иначе
			Строка = Дерево.Строки.Добавить();
			Строка.Параметр = Параметр;
			Если ТипЗнч(Ст) = Тип("Структура") 
				ИЛИ ТипЗнч(Ст) = Тип("Массив") Тогда 
				РазвернутьВДерево( Строка, Ст, Параметр );
			Иначе
				Строка.Значение =  Ст
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Дерево
КонецФункции

Функция ПолучитьСтрокуЗапросаИТело(Команда, параметрыКоманды)
	Струк = новый структура;
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	
	СтрукКоманды = новый Структура;
	Если Команда = "СписокВалют" Тогда
		СтрокаЗапроса = "tinkoff.public.invest.api.contract.v1.InstrumentsService/Currencies";
		Струк.Вставить("instrumentStatus", "INSTRUMENT_STATUS_UNSPECIFIED");
		//СтрукКоманды.Вставить("ТелоЗапроса", "{""instrumentStatus"": ""INSTRUMENT_STATUS_UNSPECIFIED""}");
		
	ИначеЕсли Команда = "СписокОперацийПоСчетуЗаПериод" Тогда
		
		СтрокаЗапроса = "tinkoff.public.invest.api.contract.v1.OperationsService/GetOperations";
		Струк.Вставить("accountId", параметрыКоманды.Аккаунт);
		Струк.Вставить("from", ЗаписатьДатуJSON(параметрыКоманды.НачДата, ФорматДатыJSON.ISO, ВариантЗаписиДатыJSON.УниверсальнаяДата));
		Струк.Вставить("to", ЗаписатьДатуJSON(параметрыКоманды.КонДата, ФорматДатыJSON.ISO, ВариантЗаписиДатыJSON.УниверсальнаяДата));
		//Струк.Вставить("from", "2023-09-01T20:54:25.167Z");
		//Струк.Вставить("to", "2023-09-13T20:54:25.167Z");
		
		Струк.Вставить("state", "OPERATION_STATE_UNSPECIFIED");
		//Струк.Вставить("figi", "string");
//{
//  "accountId": "string",
//  "from": "2023-09-13T20:54:25.167Z",
//  "to": "2023-09-13T20:54:25.167Z",
//  "state": "OPERATION_STATE_UNSPECIFIED",
//  "figi": "string"
//}		
	ИначеЕсли Команда = "ПолучитьСписокАккаунтов" Тогда
		СтрокаЗапроса = "tinkoff.public.invest.api.contract.v1.UsersService/GetAccounts";
	ИначеЕсли Команда = "ПолучитьИнформациюОПользователе" Тогда
		СтрокаЗапроса = "tinkoff.public.invest.api.contract.v1.UsersService/GetInfo";
	ИначеЕсли Команда = "ПолучитьТарифПользователя" Тогда
		СтрокаЗапроса = "tinkoff.public.invest.api.contract.v1.UsersService/GetUserTariff";
	ИначеЕсли Команда = "ПолучитьМаржинальныеПоказателиПоСчету" Тогда
		СтрокаЗапроса = "tinkoff.public.invest.api.contract.v1.UsersService/GetMarginAttributes";
		Струк.Вставить("accountId", параметрыКоманды.Аккаунт);
	КонецЕсли;
	ЗаписатьJSON(ЗаписьJSON,Струк);
	ТелоЗапроса = ЗаписьJSON.Закрыть();
	СтрукКоманды.Вставить("ТелоЗапроса", ТелоЗапроса);
	СтрукКоманды.Вставить("СтрокаЗапроса", СтрокаЗапроса);
		 
	Возврат СтрукКоманды;
КонецФункции	


&НаКлиенте                                                        
Процедура Пуск(Команда)
	Струк = новый структура;
	Струк.Вставить("НачДата", ПериодЗапроса.ДатаНачала);
	Струк.Вставить("КонДата", ПериодЗапроса.ДатаОкончания);
	Струк.Вставить("Аккаунт", Аккаунт);
	
		ПускНаСервере(ВариантЗапроса, Струк);
КонецПроцедуры


Функция Обмен(ИмяСервера, token, знач СтрокаЗапроса, Знач ТелоЗапроса)
 	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("accept", "application/json");
	Заголовки.Вставить("Authorization", "Bearer " + token);
	ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL(Неопределено, Неопределено);
	HTTPЗапрос = Новый HTTPЗапрос(СтрокаЗапроса, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	
	Соединение = Новый HTTPСоединение(ИмяСервера,,,,,, ЗащищенноеСоединение);
	
	Результат = Соединение.ОтправитьДляОбработки(HTTPЗапрос);// PUT запрос		
	
	//{"timestamp":1694636761779,"path":"/tinkoff.public.invest.api.contract.v1.InstrumentsService/Currencies","status":404,/rest,"message":null,"requestId":"5e86d689-82010644"}
	Если Результат.КодСостояния <> 201 Тогда
		
		
	Иначе
		
	КонецЕсли;
	
	ОтветТело = Результат.ПолучитьТелоКакСтроку();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Результат.ПолучитьТелоКакСтроку());
	СоответствиеРезультат = ПрочитатьJSON(ЧтениеJSON, ложь);
	возврат СоответствиеРезультат;
КонецФункции

&НаСервере
Процедура ЗагрузитьОперацииЗаПериодНаСервере(Параметры)
	//token="t.tNjSsI_aB-Zt_O5Ciwx5pE09BPYMnU_jQRFh_Tz0aZglX5scPH2pA5OM4NA7Z_UJa68As7MDD4lS2f2jQTpNJQ";
	//ИмяСервера = "invest-public-api.tinkoff.ru/rest";	
	token = Подключение.Токен;
	ИмяСервера = Подключение.Адрес;
	СтрокаЗапросаИТело = ПолучитьСтрокуЗапросаИТело("СписокВалют", Параметры);
	Рез = Обмен(ИмяСервера, token, СтрокаЗапросаИТело.СтрокаЗапроса, СтрокаЗапросаИТело.ТелоЗапроса);
	Для каждого стр из Рез.instruments Цикл //instruments / instruments
		наимВалюты = стр.isoCurrencyName;
		Рег = РегистрыСведений.Т_СоответствиеВалют.СоздатьМенеджерЗаписи();
		рег.currency = наимВалюты;
		рег.Прочитать();
		Если НЕ рег.Выбран() Тогда
			рег.currency = наимВалюты;
			рег.name = стр.name;
			рег.name = стр.name;
			рег.Записать();
		КонецЕсли;
	КонецЦикла;

	СтрокаЗапросаИТело = ПолучитьСтрокуЗапросаИТело("ПолучитьСписокАккаунтов", Параметры);
	Рез = Обмен(ИмяСервера, token, СтрокаЗапросаИТело.СтрокаЗапроса, СтрокаЗапросаИТело.ТелоЗапроса);
	Для каждого стр из Рез.accounts Цикл //accounts / accounts
		id = стр.id;
		Спр = Справочники.Т_БрокерскиеСчета.НайтиПоКоду(id);
		Если ЗначениеЗаполнено(спр) Тогда
			СпрОбъект = спр.ПолучитьОбъект();
		Иначе	
			СпрОбъект = Справочники.Т_БрокерскиеСчета.СоздатьЭлемент();
		КонецЕсли;	
		СпрОбъект.код = id;
		СпрОбъект.Наименование = стр.name;
		СпрОбъект.type = стр.type;
		СпрОбъект.status = стр.status;
		СпрОбъект.accessLevel = стр.accessLevel;

		СпрОбъект.openedDate = ПрочитатьДатуJSON(стр.openedDate, ФорматДатыJSON.ISO);
		СпрОбъект.closedDate = ПрочитатьДатуJSON(стр.closedDate, ФорматДатыJSON.ISO);
		
		
		СпрОбъект.Записать();
		
//Запрос документов по каждому аккаунту

		Параметры.Вставить("Аккаунт", id);
		СтрокаЗапросаИТело = ПолучитьСтрокуЗапросаИТело("СписокОперацийПоСчетуЗаПериод", Параметры);
		Рез = Обмен(ИмяСервера, token, СтрокаЗапросаИТело.СтрокаЗапроса, СтрокаЗапросаИТело.ТелоЗапроса);
		Для каждого стр из Рез.operations Цикл //operations / operations
			id = стр.id;
			Док = Документы.Т_ОперацияПоБрокерскомуСчету.НайтиПоНомеру(id);
			Если ЗначениеЗаполнено(Док) Тогда
				ДокОбъект = Док.ПолучитьОбъект();
			Иначе	
				ДокОбъект = Документы.Т_ОперацияПоБрокерскомуСчету.СоздатьДокумент();
			КонецЕсли;	
			ДокОбъект.Номер = id;
			ДокОбъект.Дата = ПрочитатьДатуJSON(стр.date, ФорматДатыJSON.ISO);
			ДокОбъект.БрокерскийСчет = СпрОбъект.Ссылка;
			ДокОбъект.parentOperationId = стр.parentOperationId;
			ДокОбъект.Валюта = ПолучитьВалюту(стр.currency);
			ДокОбъект.Сумма = Число(стр.payment.units) + (стр.payment.nano / 1000000000);
			ДокОбъект.Цена = стр.price.units + (стр.price.nano / 1000000000);
			
			ДокОбъект.state = стр.state;
			ДокОбъект.Количество = стр.quantity;
			ДокОбъект.quantityRest = стр.quantityRest;
			ДокОбъект.figi = стр.figi;
			ДокОбъект.ЦеннаяБумага = ПолучитьЦеннуюБумагу(стр.figi);
			ДокОбъект.Количество = стр.quantity;
			ДокОбъект.instrumentType = стр.instrumentType;
			ДокОбъект.type = стр.type;
			ДокОбъект.operationType = ПолучитьТипОПерации(стр.operationType, стр.type);
			
			ДокОбъект.assetUid = стр.assetUid;
			ДокОбъект.positionUid = стр.positionUid;
			ДокОбъект.instrumentUid = стр.instrumentUid;
			ДокОбъект.РодительскаяОперация = ПолучитьродительскуюОперацию(стр.parentOperationId);
			
			
			
			
			
			
			
			ДокОбъект.Записать();
			
		КонецЦикла;
		
	КонецЦикла;

	
КонецПроцедуры

Функция ПолучитьВалюту(currency)
	рег = РегистрыСведений.Т_СоответствиеВалют.СоздатьМенеджерЗаписи();
	рег.currency = currency;
	рег.Прочитать();
	Если рег.Выбран() Тогда
		Возврат рег.Валюта;
	Иначе
		Возврат Справочники.Валюты.ПустаяСсылка();
	КонецЕсли;
КонецФункции	

Функция ПолучитьЦеннуюБумагу(figi)
	Спр = Справочники.Т_ЦенныеБумаги.НайтиПоКоду(figi);
	Если ЗначениеЗаполнено(Спр) Тогда
		Возврат Спр.Ссылка;
	Иначе
		Спр = Справочники.Т_ЦенныеБумаги.СоздатьЭлемент();
		Спр.код = figi;
		спр.Наименование = "не обновлена";
		спр.Записать();
		Возврат спр.Ссылка;
	КонецЕсли;
	
КонецФункции	

Функция ПолучитьТипОПерации(operationType, наим)
	Спр = Справочники.Т_OperationTypes.НайтиПоКоду(operationType);
	Если ЗначениеЗаполнено(Спр) Тогда
		Возврат Спр.Ссылка;
	Иначе
		Спр = Справочники.Т_OperationTypes.СоздатьЭлемент();
		Спр.код = operationType;
		спр.Наименование = наим;
		спр.Записать();
		Возврат спр.Ссылка;
	КонецЕсли;
	
КонецФункции	

Функция ПолучитьродительскуюОперацию(parentOperationId)
	Док = Документы.Т_ОперацияПоБрокерскомуСчету.НайтиПоНомеру(parentOperationId);
	Если ЗначениеЗаполнено(Док) Тогда
		Возврат Док.Ссылка;
	Иначе
		Возврат Документы.Т_ОперацияПоБрокерскомуСчету.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции	

&НаКлиенте
Процедура ЗагрузитьОперацииЗаПериод(Команда)
	Струк = новый структура;
	Струк.Вставить("НачДата", ПериодЗапроса.ДатаНачала);
	Струк.Вставить("КонДата", ПериодЗапроса.ДатаОкончания);
	ЗагрузитьОперацииЗаПериодНаСервере(Струк);
КонецПроцедуры


