#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX_URL_LEN 1000
#define MAX_COM_LEN 1010

int downloadFiles();
int analyzeList();

int main(int argc, char **argv) {
	/* Downloads files by executing the Ruby program */
	downloadFiles();
	analyzeList();

	
	return 0;
}

int downloadFiles(){
	char command2[500] = "downloadfile.rb";
	
	system(command2);
	
	return 0;
}

int analyzeList(){
	FILE *fp, *fp2;
	int ip1, ip2, ip3, ip4, port;
	char str[100];
	
	fp = fopen("output.txt", "r");
	if(fp == NULL) {
      perror("Error opening file");
      return(-1);
	}
	
	fp2 = fopen("iplist.txt", "w");
   
   while (fgets(str, 100, fp) != NULL){
	  sscanf(str, "%d.%d.%d.%d:%d\n", &ip1, &ip2, &ip3, &ip4, &port);
	  fprintf(fp2, "%d.%d.%d.%d:%d\n", ip1, ip2, ip3, ip4, port);
	  
   }
   
	return 0;
}