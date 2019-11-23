
#pragma D option quiet

dtrace:::BEGIN
{
}



fbt:kernel:sctp_calculate_rto:entry
{
	@a[stack()] = count();
}

dtrace:::END
{
}
