from iron_worker import *

worker = IronWorker()
response = worker.upload(target="checkGames_worker.py", name="checkGames")