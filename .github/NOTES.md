When using fzf with a lot of items, use the workaround documented on this [issue](https://github.com/junegunn/fzf/issues/3346#issuecomment-2024341869):

```bash
FILES=$(ls); echo "$FILES" | fzf; unset FILES
```