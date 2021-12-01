import ../src/ngx_link_func

func init_cycle(cyc: ptr cycle_t): void {.cdecl, exportc: "ngx_link_func_init_cycle", dynlib.} =
    cyc.log_info(
        msg = "service is on".cstring
    )

func exit_cycle(cyc: ptr cycle_t): void {.cdecl, exportc: "ngx_link_func_exit_cycle", dynlib.} =
    cyc.log_info(
        msg = "service is off".cstring
    )

func request_handler(ctx: ptr ctx_t): void {.cdecl, exportc, dynlib.} =
    ctx.write_resp(
        status_code = 200.cuint,
        status_line = "200 OK".cstring,
        content_type = "text/plain".cstring,
        resp_content = "Hello from Nim!".cstring,
        len("Hello from Nim!").csize_t
    )
