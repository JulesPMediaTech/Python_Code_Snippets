def stringToBool(var):
    """Convert qualifying string variables to Boolean"""
    _allowed = ["True", "true", "False", "false"]
    if isinstance(var,bool) : return var
    if not isinstance(var,str):
        raise TypeError(f"{type(var)} Variable must be a string")
    if var not in _allowed:
        raise TypeError("Variable must contain either 'True' or 'False' values")
    return (var == "True" or var == "true")



import time
def performance_timer(func):
    """decorator for timing functions"""
    def wrapper(*args,**kwargs):
        start_time = time.perf_counter()
        result = func(*args,**kwargs)
        end_time = time.perf_counter()
        elapsed_time = end_time - start_time
        print (f"Function: {func.__name__!r} took {elapsed_time:.4f} seconds")
        return result
    return wrapper


def singleton (class_instance):
    """Singleton class decorator"""
    instances = {}
    def get_instance (*args, **kwargs):
        if class_instance not in instances:
            instances[class_instance] = class_instance(*args,**kwargs)
        return instances[class_instance]
    return get_instance

import psutil
import os
def monitor_resources():
    '''tool for CPU, Memory usage when running an app'''
    process = psutil.Process(os.getpid())
    print(f"CPU Usage: {process.cpu_percent()}%")
    print(f"Memory Usage: {process.memory_info().rss / 1024 ** 2:.2f} MB")
    root.after(5000, monitor_resources)  # Check every 5 seconds
    # 'root' being the name of instance to measure eg:

monitor_resources()
root = mainloop()


