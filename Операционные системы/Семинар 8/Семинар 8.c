#define NSIG 20
#define SIGHUB 1 //разрыв связи с терминалом
#define SIGINT 2 //сигнал завершения программы Ctrl+C
#define SIGUIT 3 // Ctrl+слэш
//...
#define SIGKILL 9
//...
#define SIGSEGV 11 // Нарушение сегментации, выход за пределы сегмента
//...
#define SIGPIPE 13 // ?Запись в канал есть, чтения нет? - недопустимая операция с каналом
#define SIGALARM 14 // Прерывание от таймера
#define SIG 15 // команда kill которая выполняется в ... режиме
#define SIGUSR1 16
#define SIGUSR2 17
#define SIGCHL 18 //сигнал который получает предок при завершении процесса потомка


#define SIG_DFL(int(*)()) 0
#define SIG_IGN(int(*)()) 1;


int kill(int pid, int sig); //
//вызов
kill(pid, sig);
//сигнал sig будет послан процессу с pid и всем потомкам процесса

//Примеры:
kill(37, SIGKILL); // Приказывает процессу с pid 37 безусловно завершиться
kill(getpid(), SIGALARM); //Процесс вызвавший kill, получит сигнал "побудки"
//getpid() - получает !собственный! идентификатор


#include <signal.h>
int main()
{
	void(*old_handlers)(int) = signal(SIGINT, SIG_IGN);
	/*действия*/
	signal(SIGINT, old_handler);
	return 0;
}


int sigaction(int sig_num, struct sigaction *action, struct sigaction *old_action);
//struct sigaction определена в <signal.h>

sigsetjmp()
siglongjmp()


mknode(<имя>, IFIFO|ACCESS,0);
//формальные параметры - с типами


msgget()
msgctl()
msgsnd()
msgrcv()

struct msg_buf
{
	long mytype; // тип сообщения
	char mytext[MSGMAX]; //то что мы пишем в этом сообщении
}


//Primer
//#include ...

#ifndef MSGMAX
#define MSGMAX 1024
#endif

struct mbuf
{
	long mtype;
	char mtext[MSGMAX];
}mobj={15, "Hello"};

int main ()
{
	int fd = msgget(100, IPC_CREATE|IPC_EXCL|0642);
	if (fd == -1 || msgsnd(fd, &mobj, strlen(mobj.mtext))+1, IPC_NOWAIT))
		perror("message");
	return 0;
}