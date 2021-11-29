void* shmat(int shmid, const mid *shmaddr, int shmflg);

int semget(key_t key, int num_sem, int flg); //верн1т дескриптор

//sem control - управлять
int semgctl(int semfd, int num, int cmd, union semun arg); //fd - file descriptor

int semop(int semfd, struct semluf *opsptr, int lim);

struct semluf
{
	nshort sem_num; //
	short sem_op; //Операция на семафоре
	short sem_fl;  //Флаги определённые на семафоре
}
	
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>

struct sem_but sbuf[2]={{0, -1, SEM_UNDO|IPC_NOWAIT},{1, 0, 1}}; //Массив структур

int main()
{
	int perms = S_IRWXV|S_IRWXG|S_IRWX_0; //Полные права доступа
	int fd segment(100, 2, IPC_CREATE|perms); //Создаёт набор из двух семафоров с идентификатором 100, возвращает файловый дескриптор
	if (fd == -1) //Набор создать не удалось
	{
		perror("semop");
		exit(1);
	}
	//Если удачно, то выполняем semop()
	if (semop(fd, sbuf, 2) == -1) //передаём
		perror("semop");
	//Если всё благополучно то
	//То есть семафор был захвачен, не освобождён, процесс завершился
	//Но система отменит изменения т.к. установлены флаги
	return 0;
}

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <string.h>

int main()
{
	int peerms = S_IRWXU|S_IRWXG|S_IRWXO; 
	//Создаётся роазделяемый сегменты с идентефикатором 100, 1024 байт
	//С полными правами
	int fd = shmget(100, 1024, IPC_CREATE|perms); 
	if (fd == -1)
	{
		perror("shmset");
		exit(1);
	}
	//Если создан, процесс пытается подключить разд. сегмент
	cahr *addr = (char*)shmat(fd, 0, 0);
	if (addr == (char*)-1)
	{
		perror("shmat");
		exit(1);
	}
	//Если получилось подключить, он записывает туда "Hello"
	strcpy(addr, "Hello");
	//Затем процесс отсоединяется от разделяемого сегмента
	if (shmdt(addr)==-1)
		perror("shmdt");
	return 0;
}

void *shmat(int shmid, const void *shmaddr, int shmflg);