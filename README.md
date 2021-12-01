Nim wrapper for ngx_link_func_module.

#### Installation

Install using `nimble`:

```bash
nimble install --accept 'git://github.com/SnwMds/ngx_link_func'
```

_**Note**: ngx_link_func requires Nim 1.0.0 or higher._

#### Usage:

Request handling:

```nim
import ngx_link_func

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
```

#### Examples

Building nginx from source:

```bash
export INSTALL_PREFIX=${HOME}/.local
export NGX_MODULE_SOURCE=/tmp/nginx-link-function
export NGX_SOURCE=/tmp/nginx

git clone --single-branch \
    --no-tags \
    --depth=1 \
    https://github.com/Taymindis/nginx-link-function \
    ${NGX_MODULE_SOURCE}

git clone --single-branch \
    --no-tags \
    --depth=1 \
    https://github.com/nginx/nginx \
    ${NGX_SOURCE}

cd "${NGX_SOURCE}"

CFLAGS="-I${NGX_MODULE_SOURCE}/src" ./auto/configure --prefix="${INSTALL_PREFIX}" \
    --add-module=${NGX_MODULE_SOURCE}

make --jobs=4
make install
```

Building shared libraries:

```bash
export WRAPPER_SRC=/tmp/ngx_link_func

git clone --single-branch \
    --no-tags \
    --depth=1 \
    https://github.com/SnwMds/ngx_link_func \
    ${WRAPPER_SRC}

cd ${WRAPPER_SRC}

nim compile \
    --app:lib \
    --out:libhello.so \
    --define:ngxSrc=${NGX_SOURCE} \
    --define:mdlSrc=${NGX_MODULE_SOURCE} \
    ./examples/simple_hello.nim
```

#### Contributing

If you have discovered a bug in this library and know how to fix it, fork this repository and open a Pull Request.
