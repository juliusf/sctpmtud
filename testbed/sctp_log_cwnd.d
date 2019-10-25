
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
}

dtrace:::END
{
	printf("\n]");
}
