# yum update is run in %post; clean up old kernel remnants
if [ $(rpm -qa | grep "^kernel-[0-9]" | wc -l) -eq 2 ]; then
  rpm -e kernel-2.6.32-642.el6.x86_64
  rpm -e kernel-devel-2.6.32-642.el6.x86_64
fi
