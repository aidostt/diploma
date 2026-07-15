# Architecture Decision Records

Каталог хранит **Architecture Decision Records (ADR)** — записи о значимых
архитектурных и инженерных решениях проекта: контекст, рассмотренные
альтернативы, принятое решение и его последствия.

ADR отвечает на вопрос «почему здесь так?» через год после того, как контекст
решения выветрился из памяти. Реализация меняется — ADR остаётся исторической
записью о том, что и почему было решено.

## Правила

- Один ADR — одно решение. Файл именуется `NNNN-kebab-title.md` со сквозной
  нумерацией.
- ADR неизменяем после принятия. Изменение решения оформляется **новым** ADR,
  который переводит старый в статус `Superseded by ADR-XXXX`.
- Значимое решение сопровождается ADR в том же изменении, что и его реализация.
- Формат — по [шаблону](template.md) (Nygard-style).

## Статусы

`Proposed` → `Accepted` → (`Superseded` | `Deprecated`).

## Индекс

| ADR | Заголовок | Статус |
|-----|-----------|--------|
| [0000](0000-use-architecture-decision-records.md) | Вести Architecture Decision Records | Accepted |
| [0001](0001-retain-microservice-topology.md) | Сохранить микросервисную топологию на текущем этапе | Accepted |
| [0002](0002-postgresql-as-single-source-of-truth.md) | PostgreSQL как единая система записи | Accepted |
| [0003](0003-client-driven-token-refresh.md) | Обновление токенов инициирует клиент | Accepted |
| [0004](0004-reservation-time-and-overlap-model.md) | Модель времени брони и защита от двойного бронирования | Accepted |
