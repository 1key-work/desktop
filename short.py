
def read(fp):
  with open(fp,encoding="utf-8") as f:
    return f.read()

def write(fp,txt):
  with open(fp,"w",encoding="utf-8") as o:
    o.write(txt)
