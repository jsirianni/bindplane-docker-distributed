# bindplane-docker-distributed

- [Architecture](#architecture)
  * [Monolithic](#monolithic)
  * [Distributed](#distributed)
    + [Kafka Event Bus](#kafka-event-bus)
    + [Postgres](#postgres)
    + [Prometheus](#prometheus)
    + [Transform Agent](#transform-agent)
    + [Loadbalancer](#loadbalancer)
- [Usage](#usage)
  * [Start](#start)
  * [Stop](#stop)
  * [Delete Stack](#delete-stack)

A Docker example implementation for BindPlane OP distributed architecture.
The deployment model shown in this guide is not intended for Production, rather,
it is to showcase what BindPlane OP looks like using the distributed model.

## Architecture

BindPlane OP supports two modes of operation, monolithic and distributed.

Monolithic mode is suitable for small, medium, and large deployments of BindPlane,
however, it lacks fault tolerance. When fault tolerance is required, BindPlane
can be configured in a distributed fashion.

This guide will focus on operating BindPlane in distributed mode.

### Monolithic

When BindPlane is installed on a Linux server, the default
mode of operation is monolithic. BindPlane does not depend
on external services.

BindPlane does manage several sub-processes
- Prometheus
- Transform Agent
These sub-processes are handled automatically and do not require
configuration by the user.

Installing BindPlane on Linux is as simple as running the installation script
and following the initialization prompts.

```bash
curl -fsSlL https://storage.googleapis.com/bindplane-op-releases/bindplane/latest/install-linux.sh -o install-linux.sh && bash install-linux.sh --init
```

Read more by checking out the [Quick Start Guide](https://observiq.com/docs/getting-started/quickstart-guide/install-bindplane-op-server).

### Distributed

When operating BindPlane OP using a distributed architecture, several components are required.

- Event bus: Kafka or Google Pub/Sub
- Shared storage: PostgreSQL
- Shared agent throughput measurements database: Prometheus
- Loadbalancer
- Remote transform agent

#### Kafka Event Bus

Kafka is used as the event bus for BindPlane. The event bus allows
BindPlane to scale horizontally and dispatch events to the appropriate
instances. When BindPlane is operating in monolithic mode on Linux,
an external event bus is not required. When BindPlane is operating
in distributed mode, Kafka or Google Pub/Sub is required.

The event bus allows multiple instances of BindPlane to coordinate events
without requiring them to know about each other. There is no concept of
a cluster and quorum.

#### Postgres

Postgres is used as the primary data store for BindPlane. Postgres
stores all configuration, agent state, and account information.

When BindPlane is operating in monolithic mode on Linux, Postgres
can be used as an optional alternative to the default Bolt Store.

When BindPlane is operating in distributed mode, Postgres is
a required component. It allows multiple instances of BindPlane
to share a common state.

Some users will opt to start with Postgres despite having a single instance
of BindPlane. This will allow them to scale up in the future without
migrating from Bolt Store to Postgres.

#### Prometheus

Prometheus is the time series database used by BindPlane to store
agent throughput measurements. Throughput measurements are used to track agent telemetry volume and reduction.

When BindPlane is operating in monolithic mode on Linux, Prometheus
is managed as a sub-process. The user does not need to deploy Prometheus
as a separate component.

When BindPlane is operating in distributed mode, a dedicated
Prometheus instance is required to allow multiple instances of
BindPlane to share a common time series database.

#### Transform Agent

The Transform Agent is used by BindPlane's processor preview feature.
It allows BindPlane to display the before and after effects of a processor.

When BindPlane is operating in monolithic mode on Linux, the Transform
Agent is managed as a sub-process of BindPlane. The user does not need
to deploy their own Transform Agent.

When BindPlane is operating in distributed mode, a dedicated transform
agent (one or more) is required.

#### Loadbalancer

When operating multiple instances of BindPlane, a load balancer
is required for distributing requests across the BindPlane
fleet.

## Usage

### Start

Start the BindPlane OP distributed stack.

```bash
make start
```

### Stop

Stop the stack.

```bash
make stop
```

### Delete Stack

Delete the stack and all data.

```bash
make delete
```
