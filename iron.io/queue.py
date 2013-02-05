from iron_worker import *

worker = IronWorker()
response = worker.queue(code_name="checkGames", run_every=120, timeout=60)