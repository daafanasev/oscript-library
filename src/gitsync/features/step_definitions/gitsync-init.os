﻿// Реализация шагов BDD-фич/сценариев c помощью фреймворка https://github.com/artbear/1bdd
#Использовать asserts
#Использовать tempfiles

Перем БДД; //контекст фреймворка 1bdd

Перем Лог;

// Метод выдает список шагов, реализованных в данном файле-шагов
Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт
	БДД = КонтекстФреймворкаBDD;

	ВсеШаги = Новый Массив;

	ВсеШаги.Добавить("ОчищаюПараметрыГитсинкВКонтексте");
	ВсеШаги.Добавить("ЯПодготовилТестовыйКаталог");
	ВсеШаги.Добавить("ЯУстановилТестовыйКаталогКакТекущий");
	ВсеШаги.Добавить("ЯПодключилКаталогТестовогоХранилищаКонфигурации");
	ВсеШаги.Добавить("ЯСоздалКаталогGit_Репозитория");
	ВсеШаги.Добавить("УстановилКаталогКакТекущий");
	ВсеШаги.Добавить("ЯСоздалКаталогИсходников");
	ВсеШаги.Добавить("ЯПередаюПутьТестовогоКаталогаХранилищаКонфигурацииДляЗапускаGitsync");
	ВсеШаги.Добавить("ЯПередаюПутьКаталогаИсходниковДляЗапускаGitsync");
	ВсеШаги.Добавить("ЯПередаюРежимОтладкиДляЗапускаGitsync");
	ВсеШаги.Добавить("ЯВыполняюКомандуGitsync");
	ВсеШаги.Добавить("ВКаталогеИсходниковСоздаетсяФайлИлиКаталог");
	ВсеШаги.Добавить("ВКаталогеИсходниковНеСоздаетсяФайлИлиКаталог");
	ВсеШаги.Добавить("ЯЗадалПутьКаталогаИсходников");

	Возврат ВсеШаги;
КонецФункции




// Реализация шагов

// Процедура выполняется перед запуском каждого сценария
Процедура ПередЗапускомСценария(Знач Узел) Экспорт
КонецПроцедуры

// Процедура выполняется после завершения каждого сценария
Процедура ПослеЗапускаСценария(Знач Узел) Экспорт
КонецПроцедуры

Функция ИмяЛога() Экспорт
	Возврат "bdd.gitsync.feature";
КонецФункции

//очищаю параметры гитсинк в контексте
Процедура ОчищаюПараметрыГитсинкВКонтексте() Экспорт
	БДД.СохранитьВКонтекст("ПараметрыГитсинк", "");	
КонецПроцедуры

//я подготовил тестовый каталог
Процедура ЯПодготовилТестовыйКаталог() Экспорт
	ВременныйКаталог = Новый Файл(ВременныеФайлы.СоздатьКаталог());
	Лог.Отладка("Использую временный каталог "+ВременныйКаталог.ПолноеИмя);

	БДД.СохранитьВКонтекст("ВременныйКаталог", ВременныйКаталог);
КонецПроцедуры

//я установил тестовый каталог как текущий
Процедура ЯУстановилТестовыйКаталогКакТекущий() Экспорт
	ВременныйКаталог = БДД.ПолучитьИзКонтекста("ВременныйКаталог");
	Лог.Отладка(СтрШаблон("ВременныйКаталог <%1>", ВременныйКаталог.ПолноеИмя));
	УстановитьТекущийКаталог(ВременныйКаталог.ПолноеИмя);
КонецПроцедуры

//я подключил каталог тестового хранилища конфигурации
Процедура ЯПодключилКаталогТестовогоХранилищаКонфигурации() Экспорт
	БДД.СохранитьВКонтекст("ПутьКФайлуХранилища1С", Новый Файл(ПутьКВременномуФайлуХранилища1С()));
КонецПроцедуры

//я создал каталог git-репозитория "git-repo"
Процедура ЯСоздалКаталогGit_Репозитория(Знач ПутьГитРепозитория) Экспорт
	ПутьГитРепозитория = ОбъединитьПути(ТекущийКаталог(), ПутьГитРепозитория);
	Лог.Отладка(СтрШаблон("ПутьГитРепозитория <%1>", ПутьГитРепозитория));
	СоздатьКаталог(ПутьГитРепозитория);
	
	КодВозврата = ИнициализироватьТестовоеХранилищеГит(ПутьГитРепозитория);
	Ожидаем.Что(КодВозврата, "неверно выполнена команда git init").Равно(0);
КонецПроцедуры

//установил каталог "git-repo" как текущий
Процедура УстановилКаталогКакТекущий(Знач ПутьКаталога) Экспорт
	УстановитьТекущийКаталог(ОбъединитьПути(ТекущийКаталог(), ПутьКаталога));
КонецПроцедуры

//я создал каталог исходников
Процедура ЯСоздалКаталогИсходников() Экспорт
	ПутьКаталогаИсходников = ОбъединитьПути(ТекущийКаталог(), "src");
	СоздатьКаталог(ПутьКаталогаИсходников);
	БДД.СохранитьВКонтекст("ПутьКаталогаИсходников", Новый Файл(ПутьКаталогаИсходников));
КонецПроцедуры

//я задал путь каталога исходников
Процедура ЯЗадалПутьКаталогаИсходников() Экспорт
	ПутьКаталогаИсходников = ОбъединитьПути(ТекущийКаталог(), "src");
	БДД.СохранитьВКонтекст("ПутьКаталогаИсходников", Новый Файл(ПутьКаталогаИсходников));
КонецПроцедуры

//я передаю путь тестового каталога хранилища конфигурации для запуска gitsync
Процедура ЯПередаюПутьТестовогоКаталогаХранилищаКонфигурацииДляЗапускаGitsync() Экспорт
	ДобавитьПараметрыГитсинк(БДД.ПолучитьИзКонтекста("ПутьКФайлуХранилища1С").ПолноеИмя);
КонецПроцедуры

//я передаю режим отладки "on" для запуска gitsync
Процедура ЯПередаюРежимОтладкиДляЗапускаGitsync(Знач РежимОтладки) Экспорт
	ДобавитьПараметрыГитсинк("-verbose "+РежимОтладки);
КонецПроцедуры

//я передаю путь каталога исходников для запуска gitsync
Процедура ЯПередаюПутьКаталогаИсходниковДляЗапускаGitsync() Экспорт
	ДобавитьПараметрыГитсинк(КаталогИсходниковИзКонтекстаБДД());
КонецПроцедуры

//я выполняю команду gitsync "init"
Процедура ЯВыполняюКомандуGitsync(Знач Команда) Экспорт
	ПутьГитсинк = ОбъединитьПути(КаталогГитсинк(), "src", "gitsync.os");

	ОжидаемыйКодВозврата = 0;

	СтрокаКоманды = СтрШаблон("oscript.exe %1 %2 %3 %4", "-encoding=utf-8", ПутьГитсинк, Команда, БДД.ПолучитьИзКонтекста("ПараметрыГитсинк"));

	ТекстФайла = "";
	КодВозврата = ВыполнитьПроцесс(СтрокаКоманды, ТекстФайла);

	БДД.СохранитьВКонтекст("ТекстЛогФайлаГитсинк", ТекстФайла);

	Если КодВозврата <> ОжидаемыйКодВозврата Тогда
		ВывестиТекст(ТекстФайла);
		Ожидаем.Что(КодВозврата, "Код возврата в ЯВыполняюКомандуGitsync").Равно(ОжидаемыйКодВозврата);
	КонецЕсли;
КонецПроцедуры

//в каталоге исходников создается файл или каталог "AUTHORS"
Процедура ВКаталогеИсходниковСоздаетсяФайлИлиКаталог(Знач ПутьФайла) Экспорт
	ИскомыйФайл = Новый Файл(ОбъединитьПути(КаталогИсходниковИзКонтекстаБДД(), ПутьФайла));
	Ожидаем.Что(ИскомыйФайл.Существует(), "Файл должен был существовать").ЭтоИстина();
КонецПроцедуры

//в каталоге исходников не создается файл или каталог ".git"
Процедура ВКаталогеИсходниковНеСоздаетсяФайлИлиКаталог(Знач ПутьФайла) Экспорт
	ИскомыйФайл = Новый Файл(ОбъединитьПути(КаталогИсходниковИзКонтекстаБДД(), ПутьФайла));
	Ожидаем.Что(ИскомыйФайл.Существует(), "Файл не должен был существовать").ЭтоЛожь();
КонецПроцедуры

Функция ВыполнитьПроцесс(Знач СтрокаВыполнения, ТекстВывода, Знач КодировкаПотока = Неопределено)
	Перем ПаузаОжиданияЧтенияБуфера;
	
	ПаузаОжиданияЧтенияБуфера = 10;
	МаксСчетчикЦикла = 100000;
	
	Если КодировкаПотока = Неопределено Тогда
		КодировкаПотока = КодировкаТекста.UTF8;
	КонецЕсли;
    Лог.Отладка("СтрокаКоманды "+СтрокаВыполнения);
	Процесс = СоздатьПроцесс(СтрокаВыполнения, ТекущийКаталог(), Истина,Истина, КодировкаПотока);
    Процесс.Запустить();
	
	ТекстВывода = "";
	Счетчик = 0; 
	
	Пока Не Процесс.Завершен Цикл 
		Текст = Процесс.ПотокВывода.Прочитать();
		Лог.Отладка("Цикл ПотокаВывода "+Текст);
		Если Текст = Неопределено ИЛИ ПустаяСтрока(Текст)  Тогда 
			Прервать;
		КонецЕсли;
		ТекстВывода = ТекстВывода + Текст;

		Счетчик = Счетчик + 1;
		Если Счетчик > МаксСчетчикЦикла Тогда 
			Прервать;
		КонецЕсли;
		
		sleep(ПаузаОжиданияЧтенияБуфера);		
	КонецЦикла;
	
	Процесс.ОжидатьЗавершения();
    
	Текст = Процесс.ПотокВывода.Прочитать();
	ТекстВывода = ТекстВывода + Текст;
	Лог.Отладка(ТекстВывода);

	Возврат Процесс.КодВозврата;
КонецФункции

Процедура ВывестиТекст(Знач Строка)

	Лог.Информация("");
	Лог.Информация("  ----------------    ----------------    ----------------  ");
	Лог.Информация( Строка );
	Лог.Информация("  ----------------    ----------------    ----------------  ");
	Лог.Информация("");

КонецПроцедуры

Процедура ДобавитьПараметрыГитсинк(Знач НовыйПараметр) Экспорт
	ПараметрыГитсинк = БДД.ПолучитьИзКонтекста("ПараметрыГитсинк");
	ПараметрыГитсинк  = СтрШаблон("%1 %2", ПараметрыГитсинк, НовыйПараметр);
	БДД.СохранитьВКонтекст("ПараметрыГитсинк", ПараметрыГитсинк);
КонецПроцедуры


Функция ИнициализироватьТестовоеХранилищеГит(Знач КаталогРепозитория, Знач КакЧистое = Ложь)

	КодВозврата = Неопределено;
	ЗапуститьПриложение("git init" + ?(КакЧистое, " --bare", ""), КаталогРепозитория, Истина, КодВозврата);
	
	Возврат КодВозврата;
	
КонецФункции

Функция КаталогИсходниковИзКонтекстаБДД()
	Возврат БДД.ПолучитьИзКонтекста("ПутьКаталогаИсходников").ПолноеИмя;	
КонецФункции // КаталогИсходниковИзКонтекстаБДД()

Функция ПутьКВременномуФайлуХранилища1С()
	
	Возврат ОбъединитьПути(КаталогFixtures(), "ТестовыйФайлХранилища1С.1CD");
	
КонецФункции

Функция КаталогFixtures()
	Возврат ОбъединитьПути(КаталогГитсинк(), "tests", "fixtures");
КонецФункции

Функция КаталогГитсинк()
	Возврат ОбъединитьПути(ТекущийСценарий().Каталог, "..", "..");
КонецФункции

Лог = Логирование.ПолучитьЛог(ИмяЛога());
//Лог.УстановитьУровень(Логирование.ПолучитьЛог("bdd").Уровень());
//Лог.УстановитьУровень(УровниЛога.Отладка);
