# Git-based Property Manager

This is a simple physical property manager that uses Git for version control and storage. It is designed to be used by a single user or a small team. It is not a full-fledged property management system, but it can be used to manage a small number of assets that have a unique identifier, such as a serial number, asset tag, or other unique and searchable identifier.

It loosely follows the Unix philosophy of "do one thing and do it well", and the KISS principle of "keep it simple, stupid" or "keep it stupid simple".

## Goals

### Primary Goals (100m)

- Simple and intuitive command-line interface
- Simple and intuitive web interface
- Small learning curve
- No database, no server, no cloud dependencies
- Automatically federated and distributed via Git

### Secondary Goals (200m)

- Automated backups with `cron`
- Dell service tag lookup & warranty status caching

## Installation

### Prerequisites

A Unix-like system with `git bash python3 grep sed fzf` installed. An internet connection is NOT required, but if you want to use the web interface, you will need a web browser. Internet connectivity is required to sync with remote repositories.

Optionally, `cron` can be used to automate backups and syncs.

## License

The code within this repository is licensed by Lucas Burlingham under The Creator's License. See more about this license at [The Creator's License](https://lucasburlingham.me/articles/20240916.0142-vghlienyzwf0b3incybmawnlbnnl). A copy is provided for you in the [.github/LICENSE.md](LICENSE.md) file.

## Inspiration

Have you ever been served with a $27k+ [FLIPL](https://www.army.mil/article/122778/financial_liability_investigation_of_property_loss_what_soldiers_civilians_should_know)? I haven't and hope you haven't either. This project is inspired by the need to keep a digital trail to compliment your offical, by-the-regs systems.
