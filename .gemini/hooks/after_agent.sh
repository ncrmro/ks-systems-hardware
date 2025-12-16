# Run tests after the agent finishes a task
# This ensures that any changes made by the agent are verified immediately.

if [ "$GEMINI_EVENT" = "after_agent" ]; then
    echo "Running post-agent tests..."
    ./bin/test
fi
