select coalesce(nutriscore_grade, 'unknown') as grade, count(*) as products
from workspace.off_verify.silver_seed_india
group by 1
