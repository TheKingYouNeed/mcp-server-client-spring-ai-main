@echo off
echo Starting MCP servers and client...

REM Start Python MCP Server in a new window
start cmd /c "cd python-mcp-server && python server.py"

REM Wait for Python server to initialize
timeout /t 3 /nobreak

REM Start Spring Boot MCP Server in a new window
start cmd /c "cd sse-mcp-server && .\mvnw.cmd spring-boot:run"

REM Wait for Spring Boot MCP Server to initialize
timeout /t 5 /nobreak

REM Start the MCP client application
cd mcp-client
echo Starting MCP client...
call .\mvnw.cmd spring-boot:run

echo All components have been started.
