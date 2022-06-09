
local L = LibStub("AceLocale-3.0"):NewLocale("PallyPowerWarn", "ruRU", false);
if not L then return end

----------------------------------------
-- These are required for functionality
----------------------------------------

L["PET_FELHUNTER"] = "Охотник скверны"
L["PET_GHOUL"] = "Вурдалак"
L["PET_IMP"] = "Бес"
L["PET_SUCCUBUS"] = "Суккуб"
-- Font Face
L["FRIZQT__.TTF"] = true
L["ARIALN.TTF"] = true
L["skurri.ttf"] = true
L["MORPHEUS.ttf"] = true
-- Not really required, but if the font changed
-- the name of the font may have changed too
L["Friz Quadrata TT"] = true
L["Arial"] = true
L["Skurri"] = true
L["Morpheus"] = true

-------------------------------------------
-- These are not required for functionality
-------------------------------------------

L["Options for PallyPowerWarn"] = "Параметры PallyPowerWarn"

L["Show UI"] = "Показать пользовательский интерфейс"
L["Shows the Graphical User Interface"] = "Показывает графический интерфейс пользователя"

L["Show version"] = "Показать версию"

L["Blessings"] = "Бафф"
L["Alerts for blessings."] = "Настройка оповещений для благословений."
L["Enable checking blessings."] = "Включить проверку благословений."

L["Seals"] = "Печать"
L["Alerts for seals."] = "Настройка оповещений для печатей."
L["Enable checking seals."] = "Включить проверку печатей."

L["Righteous Fury"] = "Агрро"
L["Alerts for Righteous Fury."] = "Настройка оповещений для праведного неистовства."
L["Enable checking Righteous Fury."] = "Включить проверку праведного неистовства."

L["Auras"] = "Аура"
L["Alerts for auras."] = "Настройка оповещений для аур."
L["Enable checking auras."] = "Включить проверку аур."

L["When to check"] = "Когда проверять"
L["Disable checks"] = "Отключить проверку"
L["Other Options"] = "Другие параметры"

L["Enable"] = "Включить"
L["Ready Check"] = "Проверка готовности"
L["Notify on ready check."] = "Уведомить о проверке готовности."
L["Enter Combat"] = "Бой начался"
L["Notify when entering combat."] = "Уведомлять при входе в бой."
L["After Combat"] = "Бой окончился"
L["Notify after the end of combat."] = "Уведомить после окончания боя."
L["No Mounted"] = "Маунт"
L["Disable notifications when mounted."] = "Отключить уведомления когда на маунте."
L["No Vehicle"] = "Транспорт"
L["Disable notifications when in a vehicle."] = "Отключить уведомления в транспортном средстве."
L["No Combat"] = "В бою"
L["Disable notifications when in combat."] = "Отключить уведомления во время боя."
L["No PvP"] = "PvP бой"
L["Disable notifications when PvP flagged."] = "Отключить уведомления в PvP бою."
L["Sound"] = "Звук"
L["Play a sound when a buff is missing."] = "Воспроизвести звук, когда бафф отсутствует."
L["Ding"] = "Ding"
L["Dong"] = "Dong"
L["None"] = "Нет"
L["Frequency"] = "Частота"
L["Do not warn more often than (5=default)"] = "Выберите промежуток оповещения в секундах."

L["Location"] = "Местоположение"
L["Battleground"] = "Поле боя"
L["Warn when in battlegrounds."] = "Предупреждать на полях сражений."
L["Arena"] = "Арена"
L["Warn when in arena."] = "Предупреждать на арене."
L["ZONE_WG"] = "ОЛО"
L["Warn when in Wintergrasp."] = "Предупреждать на Озере Ледяных Оков."
L["5-man"] = "Группа"
L["Warn when in a 5-man instance."] = "Предупреждать в инстансе на 5 игроков."
L["Raid"] = "Рейд"
L["Warn when in a raid instance."] = "Предупреждать при нахождении в рейде."
L["Other"] = "Другое"
L["Warn when not in an instance, arena, or battleground."] = "Предупреждать вне подземелий, арены или БГ."

L["Wrong Buffs"] = "Неправильные баффы"
L["Warn for wrong buffs."] = "Предупреждать о неправильных баффах."
L["Displays a warning if your blessings do not match PallyPower."] = "Показывать предупреждение, если ваши благословения не совпадают с настройкой в PallyPower."

L["Wrong Seal"] = "Неправильная печать"
L["Warn for wrong seal."] = "Предупреждать о неправильной печати."
L["Displays a warning if your seal does not match PallyPower."] = "Показывать предупреждение, если ваша печать не совпадает с настройкой в PallyPower."

L["Wrong Aura"] = "Неправильная аура"
L["Warn for wrong aura."] = "Предупреждать о неправильной ауре."
L["Any aura is fine"] = "Любая аура"
L["Warn for Crusader only"] = "Только для Crusader"
L["Non-PallyPower Aura"] = "Non-PallyPower аура"
L["Help"] = [[
Любая аура - никаких предупреждений о неправильной ауре.

Только для Crusader - будет предупреждать, если у вас есть Crusader, а для PallyPower не установлено значение Crusader.

Non-PallyPower Aura - предупредит, если ваша аура отличается от PallyPower.]]

L["Display"] = "Дисплей"
L["Settings for how to display the message."] = "Настройки отображения сообщений."

L["Color"] = "Цвет"
L["Sets the color of the text when displaying messages."] = "Устанавливает цвет текста при отображении сообщений."
L["Scroll output"] = "Текст боя"
L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"] = "Включить отправку сообщений в прокручиваемом тексте. (Настройки находятся в «Категории вывода»)"
L["Frames output"] = "Анонс в чат"
L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"] = "Включить отправку сообщений в чат. (Настройки находятся в категории «Общие настройки».)"
L["Time to display message"] = "Время отображения сообщения"
L["Set the time the message will be displayed (5=default)"] = "Установить время, в течение которого будет отображаться сообщение"

L["General Display"] = "Общие настройки"
L["General Display settings and options for the Custom Message Frame."] = "Общие настройки отображения."
L["Chat Window Options"] = "Параметры окна чата"
L["Chat Message"] = "Включить"
L["Display message in Chat Frame."] = "Отображать сообщения в чате."
L["Chat number"] = "Канал"
L["Choose which chat to display the messages in (0=default)."] = "Выберите, в каком чате отображать сообщения."
L["Error Frame"] = "Фрейм ошибок"
L["Display message in Blizzard UI Error Frame."] = "Отображать сообщение во фрейме ошибок пользовательского интерфейса Blizzard."
L["Message Frame"] = "Свой фрейм"
L["Display message in Custom Message Frame."] = "Включить пользовательский фрейм."
L["Lock"] = "Блокировка"
L["Toggle locking of the Custom Message Frame."] = "Скрыть рамку пользовательского фрейма."
L["Font Size"] = "Размер шрифта"
L["Set the font size in the Custom Message Frame."] = "Установите размер шрифта в пользовательском фрейме."
L["Font Face"] = "Шрифт"
L["Set the font face in the Custom Message Frame."] = "Выберите шрифт в пользовательском фрейме."
L["Font Effect"] = "Контур"
L["Set the font effect in the Custom Message Frame."] = "Выберите контур шрифта в пользовательском фрейме."
L["OUTLINE"] = "Тонкий"
L["THICKOUTLINE"] = "Толстый"
L["MONOCHROME"] = "Монохромный"

L[" faded from "] = " исчез с "
L["Missing Buffs"] = "Отсутствует бафф"
L["Missing Seal"] = "Отсутствует печать"
L["Missing Righteous Fury"] = "Отсутствует праведное неистовство"
L["Righteous Fury is on"] = "Неистовство включено"
L["Missing Aura"] = "Отсутствует аура"
L["Unknown"] = "Неизвестно"

L["Players missing buffs: "] = "Нет баффа: "
L["Players with wrong buffs: "] = "Неправильные баффы: "

L[" Loaded. Use /ppw for options."] = " Введите /ppw для отображения списка команд."
L["Unable to determine class_id for "] = "Невозможно определить класс для "
