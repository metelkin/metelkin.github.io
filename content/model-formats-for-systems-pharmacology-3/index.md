---
layout: post.njk
title: 'Model Formats in Systems Pharmacology. Part 3'
subtitle: 'Standardization Efforts vs Reality'
date: 2025-11-08
lastModified: 2025-11-08
description: 'A critical look at model standardization efforts in computational biology and systems pharmacology, from SBML and PharmML to PEtab. Why existing standards failed to gain adoption, and what lessons can guide the next generation of formats.'
author: Evgeny Metelkin
authorURL: https://metelkin.me
canonical: https://metelkin.me/model-formats-for-systems-pharmacology-3/
openGraph:
    title: 'Model Formats in Systems Pharmacology. Part 3: Standardization Efforts vs Reality'
    description: 'A critical look at model standardization efforts in computational biology and systems pharmacology, from SBML and PharmML to PEtab. Why existing standards failed to gain adoption, and what lessons can guide the next generation of formats.'
    url: https://metelkin.me/model-formats-for-systems-pharmacology-3/
    image: https://metelkin.me/model-formats-for-systems-pharmacology-3/img/fig0-cover.jpg
    site_name: Evgeny Metelkin
    type: article
tags:
    - SystemsPharmacology
    - SoftwareEngineering
    - modeling
    - datascience
    - pharma

---
#### [Part 1](/model-formats-for-systems-pharmacology-1/), [Part 2](/model-formats-for-systems-pharmacology-2/), **Part 3**

![Cover](./img/fig0-cover.png)

_In [Part 2](/model-formats-for-systems-pharmacology-2/), we looked at how engineering principles — transparency, modularity, and automation — can make modeling more reproducible and collaborative. In this part, we turn to the next logical question: if we agree that models should be treated as code, can we agree on how to store and exchange them?_

## 8. Why Standards Matter

Стандарты в моделировании — это не про «красивые XML». Это про то, чтобы одна и та же модель давала один и тот же результат, чтобы её можно было передать между инструментами и заново запустить через годы без охоты за скрытыми настройками. Сегодня этого часто нет: проекты заперты в .sbproj/.mod/.mlxtran и т.п., логика размазана между GUI, скриптами и «неявными» настройками солвера. В итоге модель, сделанная одной командой, не переезжает к другой, а результаты сложно проверить.

Что именно решают стандарты

1) Воспроизводимость (reproducibility).
Фиксируем в явном виде: структуру и уравнения, параметры c единицами, сценарии (дозировки, события, горизонты), наблюдаемые, настройки солвера (точности, шаги, алгоритмы), версию окружения и рандом-сиды. Тогда «те же входы → те же выходы» в независимой реализации. Это база для валидации, аудита и регуляторных требований.

2) Обмен и переносимость (interoperability).
Нужен общий «контракт»: стабильные идентификаторы сущностей (состояния, параметры, события), понятные типы объектов, единицы измерения и аннотации. Тогда модель можно безопасно импортировать в другой инструмент без ручной правки и «угадывания».

3) Долговечность (longevity).
Текстовый, открытый и проверяемый формат переживёт любой GUI. Пакет с моделью можно архивировать, цитировать, переиспользовать в новых проектах и переоценивать по мере появления данных.

Почему ODE «как универсальный язык» — недостаточно

Сами по себе дифференциальные уравнения — только ядро. На практике к ним привязаны:

- сценарии (дозы, расписания, когорты, события),
- настройки вычислений (солверы, допуски, схемы),
- данные и сопоставление (что именно измеряем, в каких единицах, как маппим на переменные модели),
- задачи (симуляция, подбор параметров, чувствительность, профили правдоподобия),
- окружение (версии библиотек/OS/контейнер).

Без стандарта для этих слоёв одна и та же «ODE-сущность» ведёт себя по‑разному. Именно здесь сегодня ломается воспроизводимость.

Что ломается без стандарта

- Несовместимость форматов и GUI-зависимость -> Единый контракт объектов и текстовый формат → импорт/экспорт без ручных хаκов
- «Где спрятаны дозы/единицы/толерансы?» -> Явные сценарии, единицы и настройки солвера в спецификации
- Невозможно автоматизировать пайплайны -> Машино‑читаемые схемы и задачи → CI/CD, массовые прогоны, отчёты
- Результаты плавают между компьютерами -> Фиксированное окружение, допуски и тест‑кейсы в пакете
- Проекты умирают с инструментом -> Открытый текстовый архив с манифестом и аннотациями

Критерии «хорошего» стандарта (проверка на здравый смысл)

- Читаемый человеком. Без расшифровки через IDE и закрытые диалоги.
- Достаточно строгий для машины. Схемы/валидация, понятные ошибки, стабильные ID.
- Малое ядро + расширения. Минимально необходимая спецификация, всё остальное — плагины/профили.
- Git‑дружелюбный. Текст, детерминированные сериализации, осмысленные diff’ы.
- Тестируемый. В пакете — эталонные сценарии и ожидаемые результаты с допусками.
- Вендорно‑нейтральный. Никаких скрытых зависимостей на конкретный софт.

Короткий пример

Команда А строит модель в инструменте с визуальным GUI; дозировки и единицы заданы в таблицах проекта, толерансы — в настройках профиля. Команда B пытается воспроизвести в своём стекe: у них другой солвер и по умолчанию другие единицы. Без стандарта они никогда не узнают, что именно не совпало.
С пакетом по стандарту — сценарии, единицы, толерансы и ожидаемые результаты лежат рядом и проверяются автоматически. Разночтения видны сразу, а не после «недели охоты за отличиями».

## 9. The Landscape of Modeling Standards

## 10. Lessons Learned


## 11. What Kind of Standards We Actually Need

1. Reproducibility & Exchange Standard
2. Human-Readable Modeling Standard
3. Validation & Testing Standard

---

**Previous: [Part 2: Engineering Practices We Can Borrow](/model-formats-for-systems-pharmacology-2/)**
