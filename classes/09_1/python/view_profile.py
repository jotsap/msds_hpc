import pstats
p = pstats.Stats('mmm.prof')
p.strip_dirs().sort_stats(-1).print_stats()

