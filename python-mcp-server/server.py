from mcp.server.fastmcp import FastMCP

mcp = FastMCP('Python-MCP-Server')

@mcp.tool()
def get_info_about(name : str) -> str:
    """
    Get Information about a given employee name:
    - First Name
    - Last Name
    - Salary
    - Email
    """
    return {
        "first_name" : name,
        "last_name" : "Mohamed",
        "salary":5400,
        "email":"med@gmail.com"
    }

if __name__ == "__main__":
    # Start the server on port 8878 using the run method
    print("Starting Python MCP Server on port 8878...")
    mcp.run()