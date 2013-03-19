import sys, os, subprocess, hashlib

def log(s):
  print(s)
  sys.stdout.flush()

def subprocess_flags():
  # this magic disables the modal dialog that windows shows if the process crashes
  # TODO: it doesn't seem to work, maybe because it was actually a crash in a process
  # sub-launched from the process I'm launching. I had to manually disable this in
  # registry, as per http://stackoverflow.com/questions/396369/how-do-i-disable-the-debug-close-application-dialog-on-windows-vista:
  # DWORD HKLM or HKCU\Software\Microsoft\Windows\Windows Error Reporting\DontShowUI = "1"
  # DWORD HKLM or HKCU\Software\Microsoft\Windows\Windows Error Reporting\Disabled = "1"
  # see: http://msdn.microsoft.com/en-us/library/bb513638.aspx
  if sys.platform.startswith("win"):
    import ctypes
    SEM_NOGPFAULTERRORBOX = 0x0002 # From MSDN
    ctypes.windll.kernel32.SetErrorMode(SEM_NOGPFAULTERRORBOX);
    return 0x8000000 #win32con.CREATE_NO_WINDOW?
  return 0

# Apparently shell argument to Popen it must be False on unix/mac and True on windows
def shell_arg():
  if os.name == "nt":
    return True
  return False

def run_cmd(*args):
  cmd = " ".join(args)
  print("run_cmd_throw: '%s'" % cmd)
  cmdproc = subprocess.Popen(args, shell=shell_arg(), stdout=subprocess.PIPE, stderr=subprocess.PIPE, creationflags=subprocess_flags())
  res = cmdproc.communicate()
  return (res[0], res[1], cmdproc.returncode)

# like run_cmd() but throws an exception on failure
def run_cmd_throw(*args):
  cmd = " ".join(args)
  print("run_cmd_throw: '%s'" % cmd)

  cmdproc = subprocess.Popen(args, shell=shell_arg(), stdout=subprocess.PIPE, stderr=subprocess.PIPE, creationflags=subprocess_flags())
  res = cmdproc.communicate()
  errcode = cmdproc.returncode
  if 0 != errcode:
    print("Failed with error code %d" % errcode)
    if len(res[0]) > 0: print("Stdout:\n%s" % res[0])
    if len(res[1]) > 0: print("Stderr:\n%s" % res[1])
    raise Exception("'%s' failed with error code %d" % (cmd, errcode))
  return (res[0], res[1])

# work-around a problem with running devenv from command-line:
# http://social.msdn.microsoft.com/Forums/en-US/msbuild/thread/9d8b9d4a-c453-4f17-8dc6-838681af90f4
def kill_msbuild():
  (stdout, stderr, err) = run_cmd("taskkill", "/F", "/IM", "msbuild.exe")
  if err not in (0, 128): # 0 is no error, 128 is 'process not found'
    print("err: %d\n%s%s" % (err, stdout, stderr))
    print("exiting")
    sys.exit(1)

def file_sha1(fp):
  data = open(fp, "rb").read()
  m = hashlib.sha1()
  m.update(data)
  return m.hexdigest()

def create_dir(d):
  if not os.path.exists(d): os.makedirs(d)
  return d
