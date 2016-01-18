import sys
import locale
import string


a = "a"
b = "b"
c = "c"

sys.stdout.write(str(locale.strcoll(a, a)))
sys.stdout.write(str(locale.strcoll(a, b)))
sys.stdout.write(str(locale.strcoll(b, a)))
