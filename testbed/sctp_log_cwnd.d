
#pragma D option quiet

dtrace:::BEGIN
{
	start = timestamp;
	printf("[\n {\"type\" : \"startTime\",  \"start_time\" : %d}\n", start);
}

fbt:kernel:sctp_log_cwnd:entry
/args[1] != NULL/
{
	printf(",{\"type\": \"cwnd\", \"time\": %d, \"cwnd\": %d}\n", (timestamp - start), args[1]->cwnd);
	printf(",{\"type\": \"rto\", \"time\": %d, \"rto\": %d}\n", (timestamp - start), args[1]->RTO);
	printf(",{\"type\": \"flight_size\", \"time\": %d, \"flight_size\": %d}\n", (timestamp - start), args[1]->flight_size);
	printf(",{\"type\": \"mtu\", \"time\": %d, \"mtu\": %d}\n", (timestamp - start), args[0]->asoc.smallest_mtu);
}

dtrace:::END
{
	printf("\n]");
}
