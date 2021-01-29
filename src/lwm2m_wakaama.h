#ifndef MyClass_h
#define MyClass_h

#include "Arduino.h"
#include "liblwm2m.h"

#define MAX_PACKET_SIZE 1024

typedef struct _connection_t
{
    struct _connection_t *  next;
    int                     sock;
    int                     addr; // struct sockaddr_in6
    size_t                  addrLen;
} connection_t;

typedef struct
{
    lwm2m_object_t * securityObjP;
    int sock;
    connection_t * connList;
    int addressFamily;
} client_data_t;

class WakaamaClient
{
  public:
    WakaamaClient(void (*f)(uint8_t * buffer, size_t length));
    void step();
    void handle_packet(int numBytes, uint8_t* buffer);
    lwm2m_context_t * lwm2mH;
    client_data_t data;
    //void (*fun_p)(uint8_t * buffer, size_t length);

  private:
};

#endif
