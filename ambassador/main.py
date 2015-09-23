#!/usr/bin/env python3
import argparse
import subprocess
import re
from docker import Client

socat_tcp_tpl = ("TCP4-LISTEN:%s,fork,reuseaddr", "TCP4:%s:%s")
socat_udp_tpl = ("UDP4-RECVFROM:%s,fork", "UDP4-SENDTO:%s:%s")


class PortRule:
    def __init__(self, from_port, to_port, protocol):
        self.protocol = protocol
        self.from_port = from_port
        self.to_port = to_port
        self.process = None

    def is_udp(self):
        return self.protocol == 'udp'

    def forward(self, target_ip):
        tpl = socat_udp_tpl if self.is_udp() else socat_tcp_tpl
        self.process = subprocess.Popen(["socat", tpl[0] % self.from_port, tpl[1] % (target_ip, self.to_port)])
        return self.process

    def __str__(self):
        return self.from_port + ":" + self.to_port + "/" + self.protocol

    def __repr__(self):
        return self.__str__()


def parse_label(label):
    index = label.index("=")
    return label[0:index], label[index + 1:]


rule_regex = re.compile("^(\d{1,5})(?::(\d{1,5}))?(?:/(tcp|udp))?$")


def parse_port_rule(rule):
    if rule_regex.match(rule) is None:
        raise ValueError("rule %s is not a value port forwarding rule" % rule)
    matches = rule_regex.findall(rule)[0]
    return PortRule(matches[0], (matches[1], matches[0])[not matches[1]], (matches[2], "tcp")[not matches[2]])


parser = argparse.ArgumentParser(description='Create a proxy targeting container in same docker host')

parser.add_argument('--label', '-l', type=str, required=True,
                    help='Label key and value, e.g. com.amazonaws.ecs.container-name=MyService',
                    dest="label_description")
parser.add_argument("--port", "-p", type=str, action="append", required=True,
                    help="Port forwarding rules. e.g: in_port[:forward_port=in_port][/protocol=tcp]",
                    dest="forwarding_rules")

args = parser.parse_args()

c = Client(base_url='unix://var/run/docker.sock')

label_name, label_value = parse_label(args.label_description)
rules = [parse_port_rule(rule) for rule in args.forwarding_rules]

target = None

for container in c.containers(filters=dict(status="running")):
    if label_name in container["Labels"] and container["Labels"][label_name] == label_value:
        target = container
        print("Target container: %s(%s)" % (target['Id'], target['Names']))
        break

if target is None:
    print("Cannot find container matching label '%s=%s'" % (label_name, label_value))
    exit(2)

container_private_ip = c.inspect_container(container=target['Id'])['NetworkSettings']['IPAddress']
processes = [rule.forward(container_private_ip) for rule in rules]
for process in processes:
    process.wait()
    print("Socat was stopped")
    exit(1)
