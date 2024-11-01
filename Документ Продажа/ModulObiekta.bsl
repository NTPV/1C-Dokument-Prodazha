Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//Ввод документа на основании документа ЗаявкаКлиента документа Продажа
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаКлиента") Тогда
		
		Клиент = ДанныеЗаполнения.Клиент;
		Комментарий = ДанныеЗаполнения.Комментарий;
		Дата = ДанныеЗаполнения.ДатаВремяВизита;
		Ответственный = ДанныеЗаполнения.Ответственный;
		Основание = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// регистр ДолгиКлиентов Приход
	Движения.ДолгиКлиентов.Записывать = Истина;
	Движение = Движения.ДолгиКлиентов.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Клиент = Клиент;
	Движение.Сумма = Сумма;
	
	// регистр УчетПродаж 
	Движения.УчетПродаж.Записывать = Истина;
	Для Каждого ТекСтрокаУслуги Из Услуги Цикл
		Движение = Движения.УчетПродаж.Добавить();
		Движение.Период = Дата;
		Движение.Клиент = Клиент; 
		Движение.Номенклатура = ТекСтрокаУслуги.Номенклатура;
		Движение.Количество = ТекСтрокаУслуги.Количество;
		Движение.Сумма = ТекСтрокаУслуги.Сумма;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписи(Отказ)   
	//При проведении документа Продажа изменяем статус документа-основания ЗаявкаКлиентана "исполнена"
	Если ЗначениеЗаполнено(Основание) Тогда 
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаявкаКлиента") Тогда
			ДокументЗаявкаКлиента = Основание.ПолучитьОбъект();
			ДокументЗаявкаКлиента.Статус = Перечисления.СтатусыЗаявок.Исполнена;
			ДокументЗаявкаКлиента.Комментарий = "Документ продажа был проведен";
			ДокументЗаявкаКлиента.Записать();
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	//Отказ отмены проведения если у документа продажа стоит галочка в статусе оплаты
	Если ЭтотОбъект.СтатусОплаты = Истина Тогда
		Отказ = Истина; 
		Сообщить("У документа " + ЭтотОбъект.Номер +" стоит галочка в статусе оплаты. С этой галочкой нельзя отменить проведение документа. Уберить галочку для отмены проведения :)");
	КонецЕсли;
	
КонецПроцедуры
