# Memory

> [Conceptual Guide](https://docs.langchain.com/docs/components/memory)

By default, Chains and Agents are stateless, meaning that they treat each incoming query 
independently (as are the underlying LLMs and chat models). In some applications (chatbots being a 
GREAT example) it is highly important to remember previous interactions, both at a short term but 
also at a long term level. The Memory does exactly that.

LangChain provides memory components in two forms. First, LangChain provides helper utilities for 
managing and manipulating previous chat messages. These are designed to be modular and useful 
regardless of how they are used. Secondly, LangChain provides easy ways to incorporate these 
utilities into chains.

- [Getting Started](/modules/memory/getting_started): An overview of different types of memory.
- How-To Guides: A collection of how-to guides. These highlight different types of memory, as well 
  as how to use memory in chains.
- [Reference](https://pub.dev/documentation/langchain): API reference documentation.