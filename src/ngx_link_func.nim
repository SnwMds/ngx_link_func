import os

when not defined(ngxSrc):
    {.fatal: "ngxSrc is not defined".}

const ngxSrc {.strdefine.}: string = ""

{.passC: "-I" & ngxSrc / "src/core".}
{.passC: "-I" & ngxSrc / "objs".}
{.passC: "-I" & ngxSrc / "src/os/unix".}
{.passC: "-I" & ngxSrc / "src/http".}
{.passC: "-I" & ngxSrc / "src/event".}
{.passC: "-I" & ngxSrc / "src/http/modules".}

when not defined(mdlSrc):
    {.fatal: "mdlSrc is not defined".}

const mdlSrc {.strdefine.}: string = ""

{.passC: "-I" & mdlSrc / "src".}
{.compile: mdlSrc / "src/ngx_link_func_module.c".}

let
    content_type_plaintext* {.header: "ngx_link_func_module.h", importc: "ngx_link_func_content_type_plaintext".}: cstring
    content_type_html* {.header: "ngx_link_func_module.h", importc: "ngx_link_func_content_type_html".}: cstring
    content_type_json* {.header: "ngx_link_func_module.h", importc: "ngx_link_func_content_type_json".}: cstring
    content_type_jsonp* {.header: "ngx_link_func_module.h", importc: "ngx_link_func_content_type_jsonp".}: cstring
    content_type_xformencoded* {.header: "ngx_link_func_module.h", importc: "ngx_link_func_content_type_xformencoded".}: cstring

type
    str_t* {.final.} = object
        len*: csize_t
        data*: cstring
    ctx_t* {.final.} = object
        req_args*: cstring
        req_body*: cstring
        req_body_len*: csize_t
        shared_mem*: void
    cycle_t* {.final.} = object
        shared_mem*: void
        has_error*: cint

func get_prop*(ctx: ptr cycle_t, key: cstring, keylen: csize_t): cstring {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_cyc_get_prop".}

func log_debug*(ctx: ptr cycle_t, msg: cstring): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_cyc_log_debug".}
func log_info*(ctx: ptr cycle_t, msg: cstring): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_cyc_log_info".}
func log_warn*(ctx: ptr cycle_t, msg: cstring): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_cyc_log_warn".}
func log_err*(ctx: ptr cycle_t, msg: cstring): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_cyc_log_err".}

func log_debug*(ctx: ptr ctx_t, msg: cstring): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_log_debug".}
func log_info*(ctx: ptr ctx_t, msg: cstring): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_log_info".}
func log_warn*(ctx: ptr ctx_t, msg: cstring): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_log_warn".}
func log_err*(ctx: ptr ctx_t, msg: cstring): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_log_err".}

func get_uri*(ctx: ptr ctx_t, str: str_t): cint {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_get_uri".}
func get_header*(ctx: ptr ctx_t, key: cstring, keylen: csize_t): cstring {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_get_header".}
func get_prop*(ctx: ptr ctx_t, key: cstring, keylen: csize_t): cstring {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_get_prop".}
func get_query_param*(ctx: ptr ctx_t, key: cstring): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_get_query_param".}
func palloc*(ctx: ptr ctx_t, size: csize_t): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_palloc".}
func pcalloc*(ctx: ptr ctx_t, size: csize_t): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_pcalloc".}
func add_header_in*(ctx: ptr ctx_t, key: string, keylen: csize_t, value: cstring, val_len: csize_t): cint {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_add_header_in".}
func add_header_out*(ctx: ptr ctx_t, key: string, keylen: csize_t, value: cstring, val_len: csize_t): cint {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_add_header_out".}

func strdup*(ctx: ptr ctx_t, src: string): cchar {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_strdup".}

func write_resp*(
    ctx: ptr ctx_t,
    status_code: cuint,
    status_line: cstring,
    content_type: cstring,
    resp_content: cstring,
    resp_len: csize_t
): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_write_resp".}


func write_resp_l*(
    ctx: ptr ctx_t,
    status_code: cuint,
    status_line: cstring,
    status_line_len: csize_t,
    content_type: cstring,
    content_type_len: csize_t,
    resp_content: cstring,
    resp_content_len: csize_t
): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_write_resp_l".}

func shmtx_trylock*(shared_mem: void): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_shmtx_trylock".}
func shmtx_lock*(shared_mem: void): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_shmtx_lock".}
func shmtx_unlock*(shared_mem: void): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_shmtx_unlock".}
func shm_alloc*(shared_mem: void, size: csize_t): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_shm_alloc".}
func shm_free*(shared_mem: void, `ptr`: void): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_shm_free".}
func shm_alloc_locked*(shared_mem: void, size: csize_t): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_shm_alloc_locked".}
func shm_free_locked*(shared_mem: void, `ptr`: void): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_shm_free_locked".}
func cache_get*(shared_mem: void, key: cstring): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_cache_get".}
func cache_put*(shared_mem: void, key: cstring, value: void): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_cache_put".}
func cache_new*(shared_mem: void, key: cstring, size: csize_t): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_cache_new".}
func cache_remove*(shared_mem: void, key: cstring): void {.cdecl, varargs, header: "ngx_link_func_module.h", importc: "ngx_link_func_cache_remove".}
