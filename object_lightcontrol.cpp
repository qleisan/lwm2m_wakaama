#include "liblwm2m.h"
#include "Arduino.h"
//#include "lwm2mclient.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define LIGHTCONTROL_OBJECT_ID  3311

/*
 * Multiple instance objects can use userdata to store data that will be shared between the different instances.
 * The lwm2m_object_t object structure - which represent every object of the liblwm2m as seen in the single instance
 * object - contain a chained list called instanceList with the object specific structure prv_instance_t:
 */
typedef struct _prv_instance_
{
    /*
     * The first two are mandatories and represent the pointer to the next instance and the ID of this one. The rest
     * is the instance scope user data (uint8_t test in this case)
     */
    struct _prv_instance_ * next;   // matches lwm2m_list_t::next
    uint16_t shortID;               // matches lwm2m_list_t::id
    //double   temp;
    bool   temp;
} prv_instance_t;


static uint8_t prv_read(uint16_t instanceId,
                        int * numDataP,
                        lwm2m_data_t ** dataArrayP,
                        lwm2m_object_t * objectP)
{
    Serial.println("qleisan - inside prv_read()");
    prv_instance_t * targetP;
    int i;

    targetP = (prv_instance_t *)lwm2m_list_find(objectP->instanceList, instanceId);
    if (NULL == targetP) return COAP_404_NOT_FOUND;
    Serial.println("qleisan - checkpoint#1");

    if (*numDataP == 0)
    {
        Serial.println("qleisan - checkpoint#2");
        *dataArrayP = lwm2m_data_new(1);
        if (*dataArrayP == NULL) return COAP_500_INTERNAL_SERVER_ERROR;
        *numDataP = 1;
        (*dataArrayP)[0].id = 1;
    }

    for (i = 0 ; i < *numDataP ; i++)
    {
        Serial.println("qleisan - checkpoint#3");
        if ((*dataArrayP)[i].type == LWM2M_TYPE_MULTIPLE_RESOURCE)
        {
            return COAP_404_NOT_FOUND;
        }

        Serial.print("qleisan #3.5  id = ");
        Serial.println((*dataArrayP)[i].id);
        switch ((*dataArrayP)[i].id)
        {
        //case 5700:
        case 5850:
            Serial.println("qleisan - checkpoint#4");
            // TODO: replace with code that read actual temperature!
            //lwm2m_data_encode_float(targetP->temp, *dataArrayP + i);
            lwm2m_data_encode_bool(targetP->temp, *dataArrayP + i);
            //targetP->temp = targetP->temp + 1.0; // dummy incrementation of temp value - remove...
            break;
        default:
            Serial.println("qleisan - checkpoint#5");
            return COAP_404_NOT_FOUND;
        }
    }

    return COAP_205_CONTENT;
}


lwm2m_object_t * get_lightcontrol_object(void)
{
    lwm2m_object_t * testObj;

    testObj = (lwm2m_object_t *)lwm2m_malloc(sizeof(lwm2m_object_t));

    if (NULL != testObj)
    {
        int i;
        prv_instance_t * targetP;

        memset(testObj, 0, sizeof(lwm2m_object_t));

        testObj->objID = LIGHTCONTROL_OBJECT_ID;
        targetP = (prv_instance_t *)lwm2m_malloc(sizeof(prv_instance_t));
        if (NULL == targetP) return NULL;
        memset(targetP, 0, sizeof(prv_instance_t));
        targetP->shortID = 0;
        //targetP->temp     = (double) 21.5; // TODO: read actual temperature
        targetP->temp     = true;
        testObj->instanceList = LWM2M_LIST_ADD(testObj->instanceList, targetP);
        testObj->readFunc = prv_read;
    }

    return testObj;
}

