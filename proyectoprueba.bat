@echo off
setlocal

:menu_principal
cls
echo 1. Registrarse
echo 2. Iniciar Sesión
echo 3. Salir

set /p choice=Ingrese su elección: 

if "%choice%"=="1" (
    call :registro
) else if "%choice%"=="2" (
    call :inicio_sesion
) else if "%choice%"=="3" (
    exit
) else (
    echo Elección no válida. Por favor, ingrese 1, 2 o 3.
    timeout /nobreak /t 2 >nul
    goto menu_principal
)

:registro
cls
set /p username=Ingrese un nombre de usuario: 
set /p password=Ingrese una contraseña: 
set /p password_confirm=Repita la contraseña: 

if "%password%" neq "%password_confirm%" (
    echo Las contraseñas no coinciden. Intenta de nuevo.
    timeout /nobreak /t 2 >nul
    goto registro
)

echo %username%:%password% >> usuarios.txt

echo Registro exitoso.
timeout /nobreak /t 2 >nul
goto menu_principal

:inicio_sesion
cls
set /p username=Ingrese su nombre de usuario: 
set /p password=Ingrese su contraseña: 

if not exist usuarios.txt (
    echo No hay usuarios registrados.
    timeout /nobreak /t 2 >nul
    goto menu_principal
)

set "valid_user="
set "valid_pass="

for /f "tokens=1,* delims=:" %%a in (usuarios.txt) do (
    if "%%a" equ "%username%" (
        set "valid_user=1"
        if "%%b" equ "%password%" set "valid_pass=1"
    )
)

if not defined valid_user (
    echo Nombre de usuario no encontrado.
    timeout /nobreak /t 2 >nul
    goto menu_principal
)

if not defined valid_pass (
    echo Contraseña incorrecta.
    timeout /nobreak /t 2 >nul
    goto menu_principal
)

echo ¡Bienvenido, %username%!
call :menu_sesion
goto menu_principal

:menu_sesion
cls
echo 1. Modificar contraseña
echo 2. Eliminar usuario
echo 3. Cerrar sesión

set /p choice=Ingrese su elección: 

if "%choice%"=="1" (
    call :modificar_contrasena
) else if "%choice%"=="2" (
    call :eliminar_usuario
) else if "%choice%"=="3" (
    goto menu_principal
) else (
    echo Elección no válida. Por favor, ingrese 1, 2 o 3.
    timeout /nobreak /t 2 >nul
    goto menu_sesion
)

:modificar_contrasena
cls
set /p new_password=Nueva contraseña: 

rem Actualizar contraseña en el archivo de usuarios
(for /f "tokens=1,* delims=:" %%a in (usuarios.txt) do (
    if "%%a" equ "%username%" (
        echo %username%:%new_password%
    ) else (
        echo %%a:%%b
    )
)) > temp.txt
move /y temp.txt usuarios.txt

echo Contraseña modificada con éxito.
timeout /nobreak /t 2 >nul
goto menu_sesion

:eliminar_usuario
cls
rem Crear un nuevo archivo sin la línea del usuario a eliminar
(for /f "tokens=1,* delims=:" %%a in (usuarios.txt) do (
    if "%%a" neq "%username%" (
        echo %%a:%%b
    )
)) > temp.txt
move /y temp.txt usuarios.txt

echo Usuario eliminado con éxito.
timeout /nobreak /t 2 >nul
goto menu_principal
