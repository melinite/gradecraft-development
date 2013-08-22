VPATH = $(HOME)/.made

base: ~/.made packages

packages: apt.update apt.upgrade \
	/usr/bin/vim /usr/bin/rsync /usr/bin/zsh /usr/bin/git /usr/bin/monit \
	/usr/bin/curl /usr/lib/exim4/exim4

/usr/bin/%:
	sudo apt-get install -y $(subst /usr/bin/,,$@)

apt.%:
	sudo apt-get $(subst apt.,,$@) -y
	touch ~/.made/$@

# A hidden directory containing intermediate files; harmless to delete.
~/.made:
	mkdir $@

define ALIASES
# /etc/aliases
mailer-daemon: postmaster
postmaster: root
nobody: root
hostmaster: root
usenet: root
news: root
webmaster: root
www: root
ftp: root
abuse: root
noc: root
security: root
root: alan@prettyrobots.com
pi: alan@prettyrobots.com
endef
export ALIASES

~/.made/aliases:
	echo "$$ALIASES" > $@

/etc/aliases: ~/.made/aliases
	sudo cp $< $@
	sudo touch $@

/etc/exim4/passwd.client:
	@while [ -z "$$SMTP_HOST" ]; do \
		read -r -p "SMTP host name: " SMTP_HOST;\
	done
	@while [ -z "$$SMTP_USER" ]; do \
		read -r -p "SMTP user name: " SMTP_USER;\
	done
	@while [ -z "$$SMTP_PASS" ]; do \
		read -r -p "SMTP user name: " SMTP_PASS;\
	done
	touch $@
	chmod 600 $@
	echo "*.$$SMTP_HOST:$$SMTP_USER:$$SMTP_PASS" > $@

/usr/lib/exim4/exim4: /etc/exim4/passwd.client /etc/exim4/update-exim4.conf.conf /etc/aliases
	sudo -E apt-get install -y exim4
	sudo touch $@
