require "spec_helper"

class ServiceNotReady < StandardError
end

sleep 10 if ENV["JENKINS_HOME"]

context "after provisioning finished" do
  targets = %w[freebsd111 freebsd103]
  targets.each do |target|
    describe server(target.to_sym) do
      targets.each do |t|
        it "pings #{t}.local" do
          result = current_server.ssh_exec("ping -c 1 #{t}.local && echo OK")
          expect(result).to match(/^OK$/)
        end
      end

      # XXX OpenBSD's either libc, or resolv.conf, does not support mdns
      it "pings openbsd62" do
        r = current_server.ssh_exec("ping -c 1 openbsd62.local && echo OK")
        expect(r).to match(/^OK$/)
      end
    end
  end
end
