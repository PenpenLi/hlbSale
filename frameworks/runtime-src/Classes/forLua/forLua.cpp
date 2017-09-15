/*
** Lua binding: forLua
** Generated automatically by tolua++-1.0.92 on 09/07/17 15:21:23.
*/

#ifndef __cplusplus
#include "stdlib.h"
#endif
#include "string.h"

#include "tolua++.h"

/* Exported function */
TOLUA_API int  tolua_forLua_open (lua_State* tolua_S);

#include <string>
#include <list>
#include <vector>
#include "cocos2d.h"
#include "cocos-ext.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
using namespace cocos2d;
using namespace cocos2d::extension;
#include "../network/http/HttpNet.h"
#include "../common/GameUtil.h"

/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 
 tolua_usertype(tolua_S,"GameUtil");
 tolua_usertype(tolua_S,"HttpNet");
}

/* method: getInstance of class  HttpNet */
#ifndef TOLUA_DISABLE_tolua_forLua_HttpNet_getInstance00
static int tolua_forLua_HttpNet_getInstance00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"HttpNet",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   HttpNet* tolua_ret = (HttpNet*)  HttpNet::getInstance();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"HttpNet");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getInstance'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: destroyInstance of class  HttpNet */
#ifndef TOLUA_DISABLE_tolua_forLua_HttpNet_destroyInstance00
static int tolua_forLua_HttpNet_destroyInstance00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"HttpNet",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   HttpNet::destroyInstance();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'destroyInstance'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: post of class  HttpNet */
#ifndef TOLUA_DISABLE_tolua_forLua_HttpNet_post00
static int tolua_forLua_HttpNet_post00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"HttpNet",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,5,&tolua_err) || !toluafix_isfunction(tolua_S,5,"LUA_FUNCTION",0,&tolua_err)) ||
     !tolua_isnumber(tolua_S,6,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,7,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,8,0,&tolua_err) ||
     !tolua_isboolean(tolua_S,9,0,&tolua_err) ||
     !tolua_isstring(tolua_S,10,1,&tolua_err) ||
     !tolua_isstring(tolua_S,11,1,&tolua_err) ||
     !tolua_isstring(tolua_S,12,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,13,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  HttpNet* self = (HttpNet*)  tolua_tousertype(tolua_S,1,0);
  const char* urlString = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* jsonString = ((const char*)  tolua_tostring(tolua_S,3,0));
  int jsonSize = ((int)  tolua_tonumber(tolua_S,4,0));
  LUA_FUNCTION funcID = (  toluafix_ref_function(tolua_S,5,0));
  int connectTime = ((int)  tolua_tonumber(tolua_S,6,0));
  int totalTime = ((int)  tolua_tonumber(tolua_S,7,0));
  bool useAsync = ((bool)  tolua_toboolean(tolua_S,8,0));
  bool usePack = ((bool)  tolua_toboolean(tolua_S,9,0));
  const char* headString = ((const char*)  tolua_tostring(tolua_S,10,nullptr));
  const char* headSplitFlag = ((const char*)  tolua_tostring(tolua_S,11,nullptr));
  const char* ssl_path = ((const char*)  tolua_tostring(tolua_S,12,nullptr));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'post'", NULL);
#endif
  {
   self->post(urlString,jsonString,jsonSize,funcID,connectTime,totalTime,useAsync,usePack,headString,headSplitFlag,ssl_path);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'post'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: get of class  HttpNet */
#ifndef TOLUA_DISABLE_tolua_forLua_HttpNet_get00
static int tolua_forLua_HttpNet_get00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"HttpNet",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,3,&tolua_err) || !toluafix_isfunction(tolua_S,3,"LUA_FUNCTION",0,&tolua_err)) ||
     !tolua_isnumber(tolua_S,4,1,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,1,&tolua_err) ||
     !tolua_isstring(tolua_S,6,1,&tolua_err) ||
     !tolua_isstring(tolua_S,7,1,&tolua_err) ||
     !tolua_isstring(tolua_S,8,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,9,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  HttpNet* self = (HttpNet*)  tolua_tousertype(tolua_S,1,0);
  const char* urlString = ((const char*)  tolua_tostring(tolua_S,2,0));
  LUA_FUNCTION funcID = (  toluafix_ref_function(tolua_S,3,0));
  int connectTime = ((int)  tolua_tonumber(tolua_S,4,7));
  int totalTime = ((int)  tolua_tonumber(tolua_S,5,7));
  const char* headString = ((const char*)  tolua_tostring(tolua_S,6,nullptr));
  const char* headSplitFlag = ((const char*)  tolua_tostring(tolua_S,7,nullptr));
  const char* ssl_path = ((const char*)  tolua_tostring(tolua_S,8,nullptr));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'get'", NULL);
#endif
  {
   self->get(urlString,funcID,connectTime,totalTime,headString,headSplitFlag,ssl_path);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'get'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: discardAllPost of class  HttpNet */
#ifndef TOLUA_DISABLE_tolua_forLua_HttpNet_discardAllPost00
static int tolua_forLua_HttpNet_discardAllPost00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"HttpNet",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  HttpNet* self = (HttpNet*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'discardAllPost'", NULL);
#endif
  {
   self->discardAllPost();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'discardAllPost'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setFailedThing of class  HttpNet */
#ifndef TOLUA_DISABLE_tolua_forLua_HttpNet_setFailedThing00
static int tolua_forLua_HttpNet_setFailedThing00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"HttpNet",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  HttpNet* self = (HttpNet*)  tolua_tousertype(tolua_S,1,0);
  bool var = ((bool)  tolua_toboolean(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'setFailedThing'", NULL);
#endif
  {
   self->setFailedThing(var);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setFailedThing'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getMD5Data of class  GameUtil */
#ifndef TOLUA_DISABLE_tolua_forLua_GameUtil_getMD5Data00
static int tolua_forLua_GameUtil_getMD5Data00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"GameUtil",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* data = ((const char*)  tolua_tostring(tolua_S,2,0));
  int dataLen = ((int)  tolua_tonumber(tolua_S,3,0));
  {
   std::string tolua_ret = (std::string)  GameUtil::getMD5Data(data,dataLen);
   tolua_pushcppstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getMD5Data'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getMD5String of class  GameUtil */
#ifndef TOLUA_DISABLE_tolua_forLua_GameUtil_getMD5String00
static int tolua_forLua_GameUtil_getMD5String00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"GameUtil",0,&tolua_err) ||
     !tolua_iscppstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  std::string str = ((std::string)  tolua_tocppstring(tolua_S,2,0));
  {
   std::string tolua_ret = (std::string)  GameUtil::getMD5String(str);
   tolua_pushcppstring(tolua_S,(const char*)tolua_ret);
   tolua_pushcppstring(tolua_S,(const char*)str);
  }
 }
 return 2;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getMD5String'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_forLua_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"HttpNet","HttpNet","",NULL);
  tolua_beginmodule(tolua_S,"HttpNet");
   tolua_function(tolua_S,"getInstance",tolua_forLua_HttpNet_getInstance00);
   tolua_function(tolua_S,"destroyInstance",tolua_forLua_HttpNet_destroyInstance00);
   tolua_function(tolua_S,"post",tolua_forLua_HttpNet_post00);
   tolua_function(tolua_S,"get",tolua_forLua_HttpNet_get00);
   tolua_function(tolua_S,"discardAllPost",tolua_forLua_HttpNet_discardAllPost00);
   tolua_function(tolua_S,"setFailedThing",tolua_forLua_HttpNet_setFailedThing00);
  tolua_endmodule(tolua_S);
  tolua_cclass(tolua_S,"GameUtil","GameUtil","",NULL);
  tolua_beginmodule(tolua_S,"GameUtil");
   tolua_function(tolua_S,"getMD5Data",tolua_forLua_GameUtil_getMD5Data00);
   tolua_function(tolua_S,"getMD5String",tolua_forLua_GameUtil_getMD5String00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_forLua (lua_State* tolua_S) {
 return tolua_forLua_open(tolua_S);
};
#endif

