#include <fcgi_stdio.h>
#include <stdlib.h>
#include <signal.h>

char pathinfo[0x80];
char r_dir[0x40];

void send_file(const char *filepath, FCGX_Stream *out)
{
	char buf[0x50];
	memset(buf, 0, 0x50);
	snprintf(buf, 0x41, "%s/%s", r_dir, filepath);

	FILE *f = fopen(buf, "r");
	if (f)
	{
		char buffer[1024];
		size_t bytes;

		FCGX_PutS("Content-type: image/jpeg\r\n\r\n", out);

		while ((bytes = fread(buffer, 1, sizeof(buffer), f)) > 0)
		{
			FCGX_PutStr(buffer, bytes, out);
		}

		fclose(f);
	}
	else
	{
		FCGX_PutS("Status: 404 Not Found\r\n", out);
		FCGX_PutS("Content-type: text/plain\r\n\r\n", out);
		FCGX_PutS("404 Page Not Found\r\n", out);
	}
}

void init()
{
	sprintf(r_dir, "images");
}

char *getimage()
{
	srand(time(NULL));
	switch (rand() % 3)
	{
	case 0:
		return "500.jpg";
	case 1:
		return "501.jpg";
	case 2:
		return "502.jpg";
	default:
		return "503.jpg";
	}
}

int main(void)
{
	FCGX_Stream *in, *out, *err;
	FCGX_ParamArray envp;
	init();
	signal(SIGCHLD, SIG_IGN);
	while (FCGX_Accept(&in, &out, &err, &envp) >= 0)
	{
		int pid = fork();
		if(pid < 0 ) continue;
		if(pid == 0) {
			char *uri = FCGX_GetParam("PATH_INFO", envp);
			if(strlen(uri) < 256){
					strncpy(pathinfo,uri,strlen(uri));
			}

			if (!strncmp("img", uri, strlen("img")))
			{
				char *filename = getimage();
				send_file(filename, out);
			}
			else if (!strncmp("ping", uri, 4))
			{

				FCGX_PutS("Content-type: text/plain\r\n\r\n", out);
				FCGX_PutS("pong", out);
				FCGX_PutS("\r\n", out);
			}
			else
			{
				FCGX_PutS("Content-type: text/plain\r\n\r\n", out);
				FCGX_PutS("Status: 404 Not Found\r\n", out);
				FCGX_PutS("404 Page Not Found\r\n", out);
			}
			FCGX_Finish();
			exit(0);
		} else {
			waitpid(pid, NULL, 0);
		}
	}
	return 0;
}
