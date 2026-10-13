---
title: Platform verification sandbox
---

Real aggregate numbers measured while verifying a data platform design. Data: Open Food Facts (ODbL).

## Daily OFF change files

```sql delta
select cast(day as date) as day, size_mb from off_aggregates.delta_files order by day
```

<BarChart data={delta} x=day y=size_mb title="Size of each daily change file (MB)" />

## Products per market in 13 days of changes

```sql markets
select market, products from off_aggregates.market_counts order by products desc
```

<BarChart data={markets} x=market y=products swapXY=true title="Changed products by market" />

Contains data from Open Food Facts, available under the Open Database License.
