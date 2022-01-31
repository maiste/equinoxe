#ifdef _WIN32
#define CAML_NAME_SPACE
#define CAML_INTERNALS
#include <caml/misc.h>
#include <caml/osdeps.h>
#endif

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/alloc.h>
#include <stdlib.h>

/* FS case */

#ifdef __APPLE__

#include <fcntl.h>
#include <sys/param.h>
#include <unistd.h>

value ml_merlin_fs_exact_case(value path)
{
	CAMLparam1(path);
	CAMLlocal1(realpath);
	char realpath_c[MAXPATHLEN];

	realpath = path;

	int fd = open(String_val(path), O_EVTONLY | O_SYMLINK);
	if (fd != -1)
	{
		if (fcntl(fd, F_GETPATH, realpath_c) != -1)
		{
			realpath = caml_copy_string(realpath_c);
		}
		close(fd);
	}
	CAMLreturn(realpath);
}


#else

value ml_merlin_fs_exact_case(value path)
{
	return path;
}

#endif
#ifdef _WIN32

/* File descriptor inheritance */

#include <windows.h>
#include <io.h>

value ml_merlin_dont_inherit_stdio(value vstatus)
{
  int status = Int_val(vstatus) ? 0 : HANDLE_FLAG_INHERIT;
  SetHandleInformation((HANDLE)_get_osfhandle(1), HANDLE_FLAG_INHERIT, status);
  SetHandleInformation((HANDLE)_get_osfhandle(2), HANDLE_FLAG_INHERIT, status);
  return Val_unit;
}

/* Run ppx-command without opening a sub console */

static int windows_system(const char *cmd)
{
    PROCESS_INFORMATION p_info;
    STARTUPINFOW s_info;
    DWORD ReturnValue;

    memset(&s_info, 0, sizeof(s_info));
    memset(&p_info, 0, sizeof(p_info));
    s_info.cb = sizeof(s_info);

    char_os *utf16cmd;
    utf16cmd = caml_stat_strdup_to_os(cmd);
    if (CreateProcessW(NULL, utf16cmd, NULL, NULL, FALSE, CREATE_NO_WINDOW, NULL, NULL, &s_info, &p_info))
    {
        WaitForSingleObject(p_info.hProcess, INFINITE);
        GetExitCodeProcess(p_info.hProcess, &ReturnValue);
        CloseHandle(p_info.hProcess);
        CloseHandle(p_info.hThread);

        caml_stat_free(utf16cmd);
        return ReturnValue;
    }
    else
    {
        caml_stat_free(utf16cmd);
        return -1;
    }
}

value ml_merlin_system_command(value command)
{
  return Val_int(windows_system(String_val(command)));
}

#else

value ml_merlin_dont_inherit_stdio(value vstatus)
{
  (void)vstatus;
  return Val_unit;
}

value ml_merlin_system_command(value command)
{
  return Val_int(system(String_val(command)));
}

#endif
