# Previewing Vocabulary in GitHub Codespaces

1. In the GitHub repo, go to **Code → Codespaces → Create codespace on main**. This starts a VS Code environment and brings up Skosmos in Docker for preview.

   ![Create codespace](images/create_codespace.png)

2. Wait a few minutes for containers to start. Once it is ready you can find the links to Skosmos in terminal.

   ![Open Skosmos](images/containers_ready.png)

3. Open the link in a browser, then click on **English** to view the taxonomy.
4. If you make changes to the vocabulary, press **F1** and run **Codespaces: Rebuild Container** to restart services with the new changes.
5. If the container doesn’t start, press **F1** and run **Codespaces: View creation log** to see startup logs.
6. When you’re done, delete the Codespace (free plan includes ~60 hours/month).
