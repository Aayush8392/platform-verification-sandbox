select market, count(*) as products
from workspace.off_verify.catalogue_test
group by market
