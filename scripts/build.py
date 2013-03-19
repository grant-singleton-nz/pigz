"""
Build pigz and run tests.
Requirers premake to be installed in %PATH% (http://industriousone.com/premake)
The final binary will be in rel/pigz.exe and rel/unpigz.exe.
"""
import os, shutil, util

g_script_path = os.path.realpath(os.path.dirname(__file__))
def top_dir():
	return os.path.realpath(os.path.join(g_script_path, ".."))

def pigz_path():
	return top_dir()

def cd_to_pigz():
	path = pigz_path()
	assert os.path.exists(path)
	os.chdir(path)
	assert os.path.exists("pigz.c")

def rm_dirs(dirs):
	for dir in dirs:
		shutil.rmtree(dir, ignore_errors=True)

def clean():
	rm_dirs(["build", "rel", "pigz_test_tmp"])

def build():
	util.run_cmd_throw("premake4", "vs2010")
	os.chdir("build")
	util.kill_msbuild()
	util.run_cmd_throw("devenv", "pigz.sln", "/Build", "Release", "/Project", "pigz.vcxproj")
	os.chdir(os.path.join("..", "rel"))
	assert os.path.exists("pigz.exe")
	# yes, those are the same files, the binary decides what it is based on its name
	shutil.copyfile("pigz.exe", "unpigz.exe")

def test_one_with_flag(sha1_orig, suffix, flag1):
	pigz_exe = os.path.join("..", "rel", "pigz.exe")
	unpigz_exe = os.path.join("..", "rel", "unpigz.exe")
	util.run_cmd_throw(pigz_exe, flag1, "pigz.c")
	util.run_cmd_throw(pigz_exe, "-t", "pigz.c" + suffix)
	util.run_cmd_throw(unpigz_exe, "pigz.c" + suffix)
	assert sha1_orig == util.file_sha1("pigz.c")

# Note: I'm sure there's clever python syntax to unify this with test_one_with_flag
# I just don't know it
def test_one_with_flag2(sha1_orig, suffix, flag1, flag2):
	pigz_exe = os.path.join("..", "rel", "pigz.exe")
	unpigz_exe = os.path.join("..", "rel", "unpigz.exe")
	util.run_cmd_throw(pigz_exe, flag1, flag2, "pigz.c")
	util.run_cmd_throw(pigz_exe, "-t", "pigz.c" + suffix)
	util.run_cmd_throw(unpigz_exe, "pigz.c" + suffix)
	assert sha1_orig == util.file_sha1("pigz.c")

def test():
	cd_to_pigz()
	util.create_dir("pigz_test_tmp")
	shutil.copyfile("pigz.c", os.path.join("pigz_test_tmp", "pigz.c"))

	os.chdir("pigz_test_tmp")
	sha1_orig = util.file_sha1("pigz.c")
	test_one_with_flag(sha1_orig, ".gz", "-f")
	test_one_with_flag2(sha1_orig, ".gz", "-fb", "32")
	test_one_with_flag2(sha1_orig, ".gz", "-fp", "1")
	test_one_with_flag(sha1_orig, ".zz", "-fz")
	test_one_with_flag(sha1_orig, ".zip", "-fK")
	test_one_with_flag2(sha1_orig, ".gz", "-11", "-f")
	# TODO: more tests for stdin/stdout
	# TODO: compare with gzip/compress (if available in path)

def main():
	# just to be sure, only support window's python (i.e. not cygwin's)
	assert os.name == "nt"
	cd_to_pigz()
	clean()
	build()
	test()

if __name__ == "__main__":
	main()
