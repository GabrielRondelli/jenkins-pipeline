#!groovy


currentBuild.result = "SUCCESS"

try {
	node('lamp') {
		stage('Deploy') {
			ansiblePlaybook( 
				playbook: '../ansible-callback-web/site.yml',
				inventory: '../ansible-callback-web/hosts'
			)
		}
		stage('Test'){
			sh 'run_rake_tests.sh'
		}
	}
}catch (err) {
	currentBuild.result = "FAILURE"

            mail body: "project build error is here: ${env.BUILD_URL}" ,
            from: 'xxxx@yyyy.com',
            replyTo: 'yyyy@yyyy.com',
            subject: 'project build failed',
            to: 'zzzz@yyyyy.com'

	throw err
}
